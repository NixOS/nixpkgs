{ stdenv, fetchFromGitLab, buildGoPackage, ruby, bundlerEnv }:

let
  rubyEnv = bundlerEnv {
    name = "gitaly-env";
    inherit ruby;
    gemdir = ./.;
  };
in buildGoPackage rec {
  version = "0.38.0";
  name = "gitaly-${version}";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "02s5gjxbjvm990n4h5zkyqj71a9mp4yj83hfl8mma0g7gx00icsf";
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
