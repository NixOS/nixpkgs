{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage  rec {
  name = "micro-${version}";
  version = "1.3.4";

  goPackagePath = "github.com/zyedidia/micro";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "micro";
    rev = "v${version}";
    sha256 = "1giyp2xk2rb6vdyfnj5wa7qb9fwbcmmwm16wdlnmq7xnp7qamdkw";
    fetchSubmodules = true;
  };

  subPackages = [ "cmd/micro" ];

  buildFlagsArray = [ "-ldflags=" "-X main.Version=${version}" ];

  meta = with stdenv.lib; {
    homepage = https://micro-editor.github.io;
    description = "Modern and intuitive terminal-based text editor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

