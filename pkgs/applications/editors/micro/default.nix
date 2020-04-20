{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage  rec {
  pname = "micro";
  version = "2.0.3";

  goPackagePath = "github.com/zyedidia/micro";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "micro";
    rev = "v${version}";
    sha256 = "017m9kb3gfrgzd06f1nma1i3m5rb0hzpgdikb86lsyv8ik18y12z";
    fetchSubmodules = true;
  };

  subPackages = [ "cmd/micro" ];

  buildFlagsArray = [ "-ldflags=" "-X ${goPackagePath}/internal/util.Version=${version}" ];

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = "https://micro-editor.github.io";
    description = "Modern and intuitive terminal-based text editor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

