{
  stdenv,
  lib,
  jekyll,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "jsonnet";
  version = "0.21.0";
  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "jsonnet";
    sha256 = "sha256-QHp0DOu/pqcgN7di219cHzfFb7fWtdGGE6J1ZXgbOGQ=";
  };

  patches = [
    # ref. https://github.com/google/jsonnet/pull/1249 merged upstream
    (fetchpatch {
      url = "https://github.com/google/jsonnet/commit/6c87c1b0e1e18d25898be071c1b231e264f05a8c.patch";
      hash = "sha256-KprhMKwUCpvLiMT/grfqZ8Vt9rbosIizQgNMStuV8/U=";
    })
  ];

  nativeBuildInputs = [
    jekyll
    cmake
  ];
  buildInputs = [ gtest ];

  cmakeFlags = [
    "-DUSE_SYSTEM_GTEST=ON"
    "-DBUILD_STATIC_LIBS=${if stdenv.hostPlatform.isStatic then "ON" else "OFF"}"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "-DBUILD_SHARED_BINARIES=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

  enableParallelBuilding = true;

  # Upstream writes documentation in html, not in markdown/rst, so no
  # other output formats, sorry.
  postBuild = ''
    jekyll build --source ../doc --destination ./html
  '';

  postInstall = ''
    mkdir -p $out/share/doc/jsonnet
    cp -r ./html $out/share/doc/jsonnet
  '';

  meta = {
    description = "Purely-functional configuration language that helps you define JSON data";
    maintainers = with lib.maintainers; [
      benley
    ];
    license = lib.licenses.asl20;
    homepage = "https://github.com/google/jsonnet";
    platforms = lib.platforms.unix;
  };
}
