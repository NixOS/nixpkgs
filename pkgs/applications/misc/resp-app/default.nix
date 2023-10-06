{ stdenv
, mkDerivation
, lib
, fetchFromGitHub
, fetchpatch
, brotli
, lz4
, pyotherside
, python3
, python3Packages
, qtbase
, qtcharts
, qmake
, qttools
, rdbtools
, snappy
, wrapQtAppsHook
, zstd
}:

let
  rdbtools-patched = rdbtools.overridePythonAttrs (oldAttrs: {
    # Add required additional flag for resp-app
    patches = [
      (fetchpatch {
        name = "Add-flag-to-parse-only-key-names.patch";
        url = "https://github.com/uglide/redis-rdb-tools/commit/b74946e6fbca589947ef0186429d5ce45a074b87.patch";
        hash = "sha256-1gjqB/IDSsAbrwzWSezlAW/2SYr6BFm1QJ2HAHK2fFs=";
      })
    ];
  });
in
mkDerivation rec {
  pname = "RESP.app";
  version = "2022.5";

  src = fetchFromGitHub {
    owner = "RedisInsight";
    repo = "RedisDesktopManager";
    fetchSubmodules = true;
    rev = version;
    sha256 = "sha256-5eI3J2RsYE5Ejb1r8YkgzmGX2FyaCLFD0lc10J+fOT4=";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    brotli
    lz4
    pyotherside
    python3
    qtbase
    qtcharts
    qttools
    snappy
    zstd
  ] ++ pythonPath;


  pythonPath = with python3Packages; [
    bitstring
    cbor
    msgpack
    phpserialize
    rdbtools-patched
    python-lzf
  ];

  postPatch = ''
    substituteInPlace src/resp.pro \
      --replace 'which ccache' "false" \
      --replace 'target.files = $$DESTDIR/resp' "${placeholder "src"}/bin/linux/release/resp" \
      --replace '/opt/resp_app' "${placeholder "out"}" \
      --replace 'target.path = $$LINUX_INSTALL_PATH' 'target.path = $$LINUX_INSTALL_PATH/bin' \
      --replace '/usr/' "$out/"
  '';

  qmakeFlags = [
    "SYSTEM_LZ4=1"
    "SYSTEM_ZSTD=1"
    "SYSTEM_SNAPPY=1"
    "SYSTEM_BROTLI=1"
    "VERSION=${version}"
    "src/resp.pro"
  ];

  preFixup = ''
    buildPythonPath "$pythonPath"
    qtWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = with lib; {
    description = "Cross-platform Developer GUI for Redis";
    homepage = "https://resp.app/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
