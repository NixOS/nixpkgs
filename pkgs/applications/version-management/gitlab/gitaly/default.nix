{ stdenv, fetchFromGitLab, buildGoPackage, ruby, bundlerEnv }:

let
  rubyEnv = bundlerEnv {
    name = "gitaly-env";
    inherit ruby;
    gemdir = ./.;
  };
in buildGoPackage rec {
  version = "1.34.3";
  name = "gitaly-${version}";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "0lv3czkxcan2zv9asd79nn8z1bihyxszi1d5hazmb299v23cppzm";
  };

  goPackagePath = "gitlab.com/gitlab-org/gitaly";

  passthru = {
    inherit rubyEnv;
  };

  buildInputs = [ rubyEnv.wrappedRuby ];

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib,git-hooks,gitlab-shell} $ruby

    # gitlab-shell will try to read its config relative to the source
    # code by default which doesn't work in nixos because it's a
    # read-only filesystem
    substituteInPlace $ruby/gitlab-shell/lib/gitlab_config.rb --replace \
       "File.join(ROOT_PATH, 'config.yml')" \
       "'/run/gitlab/shell-config.yml'"
  '';

  outputs = [ "bin" "out" "ruby" ];

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ roblabla ];
    license = licenses.mit;
  };
}
