{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "ada";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "ada-url";
    repo = "ada";
    tag = "v${version}";
    hash = "sha256-WQjScror93W7E8j34PbVL6FENy83MpnirTgit3/+dWw=";
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
