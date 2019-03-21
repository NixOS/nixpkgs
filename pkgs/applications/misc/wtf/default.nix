{ buildGoPackage
, fetchFromGitHub
, lib
}:

buildGoPackage rec {
  name = "wtf-${version}";
  version = "0.4.0";

  goPackagePath = "github.com/senorprogrammer/wtf";

  src = fetchFromGitHub {
    owner = "senorprogrammer";
    repo = "wtf";
    rev = "${version}";
    sha256 = "1vgjqmw27baiq9brmnafic3w3hw11p5qc6ahbdxi5n5n4bx7j6vn";
  };

  buildFlagsArray = [ "-ldflags=" "-X main.version=${version}" ];

  meta = with lib; {
    description = "The personal information dashboard for your terminal";
    homepage = http://wtfutil.com/;
    license = licenses.mpl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
