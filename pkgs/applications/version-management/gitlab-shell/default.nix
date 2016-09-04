{ stdenv, ruby, bundler, fetchFromGitLab }:

stdenv.mkDerivation rec {
  version = "3.4.0";
  name = "gitlab-shell-${version}";

  srcs = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "1vhwsiz6n96i6cbcqbf4pa93nzx4xkaph2lmzh0nm4mi5ydl49is";
  };

  buildInputs = [
    ruby bundler
  ];

  patches = [ ./remove-hardcoded-locations.patch ];

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/

    # Nothing to install ATM for non-development but keeping the
    # install command anyway in case that changes in the future:
    export HOME=$(pwd)
    bundle install -j4 --verbose --local --deployment --without development test
  '';

  # gitlab-shell will try to read its config relative to the source
  # code by default which doesn't work in nixos because it's a
  # read-only filesystem
  postPatch = ''
    substituteInPlace lib/gitlab_config.rb --replace\
       "File.join(ROOT_PATH, 'config.yml')"\
       "ENV['GITLAB_SHELL_CONFIG_PATH']"

    # Note that we're running gitlab-shell from current-system/sw
    # because otherwise updating gitlab-shell won't be reflected in
    # the hardcoded path of the authorized-keys file:
    substituteInPlace lib/gitlab_keys.rb --replace\
        "\"#{ROOT_PATH}/bin/gitlab-shell"\
        "\"GITLAB_SHELL_CONFIG_PATH=#{ENV['GITLAB_SHELL_CONFIG_PATH']} /run/current-system/sw/bin/gitlab-shell"

    # We're setting GITLAB_SHELL_CONFIG_PATH in the ssh authorized key
    # environment because we need it in gitlab_configrb
    # . unsetenv_others will remove that so we're not doing it for
    # now.
    #
    # TODO: Are there any security implications? The commit adding
    # unsetenv_others didn't mention anything...
    # 
    # Kernel::exec({'PATH' => ENV['PATH'], 'LD_LIBRARY_PATH' => ENV['LD_LIBRARY_PATH'], 'GL_ID' => ENV['GL_ID']}, *args, unsetenv_others: true)
    substituteInPlace lib/gitlab_shell.rb --replace\
        " *args, unsetenv_others: true)"\
        " *args)"
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
