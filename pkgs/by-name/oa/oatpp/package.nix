{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "oatpp";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "oatpp";
    repo = "oatpp";
    rev = version;
    sha256 = "sha256-pTQ0DD4naE9m+6FfCVGg/i3WpNbtaR+38yyqjqN0uH0=";
  };

  nativeBuildInputs = [ cmake ];

  # Tests fail on darwin. See https://github.com/NixOS/nixpkgs/pull/105419#issuecomment-735826894
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    homepage = "https://oatpp.io/";
    description = "Light and powerful C++ web framework for highly scalable and resource-efficient web applications";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
