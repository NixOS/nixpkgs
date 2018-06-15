{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage  rec {
  name = "micro-${version}";
  version = "1.4.0";

  goPackagePath = "github.com/zyedidia/micro";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "micro";
    rev = "v${version}";
    sha256 = "0w1rmh81h28n1jlb05k89i751h498i6p883hrsjr70hvrwq5zjpb";
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

