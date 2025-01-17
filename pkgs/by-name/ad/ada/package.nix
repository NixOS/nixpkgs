{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "ada";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "ada-url";
    repo = "ada";
    rev = "v${version}";
    hash = "sha256-VWFxupmgc+fq9aj/02uMEsiwhP+9PWMSleoIoyKVe3c=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # uses CPM that requires network access
    (lib.cmakeBool "ADA_TOOLS" false)
    (lib.cmakeBool "ADA_TESTING" false)
  ];

  meta = {
    description = "WHATWG-compliant and fast URL parser written in modern C";
    homepage = "https://github.com/ada-url/ada";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = lib.platforms.all;
  };
}
