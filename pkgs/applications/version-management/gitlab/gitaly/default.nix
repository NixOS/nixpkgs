{ stdenv, fetchFromGitLab, buildGoPackage, ruby, bundlerEnv }:

let
  rubyEnv = bundlerEnv {
    name = "gitaly-env";
    inherit ruby;
    gemdir = ./.;
  };
in buildGoPackage rec {
  version = "1.27.1";
  name = "gitaly-${version}";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitaly";
    rev = "v${version}";
    sha256 = "0sr1jjw1rvyxrv6vaqvl138m0x2xgjksjdy92ajslrjxrnjlrjvp";
  };

  goPackagePath = "gitlab.com/gitlab-org/gitaly";

  passthru = {
    inherit rubyEnv;
  };

  buildInputs = [ rubyEnv.wrappedRuby ];

  postInstall = ''
    mkdir -p $ruby
    cp -rv $src/ruby/{bin,lib} $ruby
  '';

  outputs = [ "bin" "out" "ruby" ];

  meta = with stdenv.lib; {
    homepage = http://www.gitlab.com/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ roblabla ];
    license = licenses.mit;
  };
}
