{ stdenv, ruby, bundler, fetchFromGitLab, go }:

stdenv.mkDerivation rec {
  version = "8.4.1";
  name = "gitlab-shell-${version}";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "00jzrpdfqgrba2qi5ngc0g07p7gmip7my563hw542gg8l88d27xq";
  };

  buildInputs = [ ruby bundler go ];

  patches = [ ./remove-hardcoded-locations.patch ];

  installPhase = ''
    ruby bin/compile
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
    substituteInPlace lib/gitlab_config.rb --replace \
       "File.join(ROOT_PATH, 'config.yml')" \
       "'/run/gitlab/shell-config.yml'"
  '';

  meta = with stdenv.lib; {
    description = "SSH access and repository management app for GitLab";
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz globin ];
    license = licenses.mit;
  };
}
