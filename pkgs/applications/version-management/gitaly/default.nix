{ stdenv, fetchFromGitLab, buildGoPackage, ruby, bundlerEnv }:

let
  rubyEnv = bundlerEnv {
    name = "gitaly-env";
    inherit ruby;
    gemdir = ./.;
  };
in buildGoPackage rec {
  version = "0.35.0";
  name = "gitaly-${version}";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "0h3gh4y571wrnnsg5wpi67psih8yssaw24v3vrcpqpkz5linj7pl";
  };

  goPackagePath = "gitlab.com/gitlab-org/gitaly";

  passthru = {
    inherit rubyEnv;
  };

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib,vendor} $ruby
  '';

  outputs = [ "bin" "out" "ruby" ];

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ roblabla ];
    license = licenses.mit;
  };
}
