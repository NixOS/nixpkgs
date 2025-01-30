{ fetchFromGitHub
, lib
, stdenv
, autoreconfHook
, pkg-config
, gettext
, python3
, texinfo
, help2man
, libyaml
, perl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblouis";
  version = "3.32.0";

  outputs = [ "out" "dev" "info" "doc" ]
    # configure: WARNING: cannot generate manual pages while cross compiling
    ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ "man" ];

  src = fetchFromGitHub {
    owner = "liblouis";
    repo = "liblouis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gub/XUwbM7wzeQ0eXtpqaWxPDhlksVW7xSnFB6oXNyQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
    python3
    python3.pkgs.build
    python3.pkgs.installer
    python3.pkgs.setuptools
    python3.pkgs.wheel
    # Docs, man, info
    texinfo
    help2man
  ];

  buildInputs = [
    # lou_checkYaml
    libyaml
  ];

  nativeCheckInputs = [
    perl
  ];

  configureFlags = [
    # Required by Python bindings
    "--enable-ucs4"
  ];

  postPatch = ''
    patchShebangs tests
    substituteInPlace python/louis/__init__.py.in --replace "###LIBLOUIS_SONAME###" "$out/lib/liblouis.so"
  '';

  postInstall = ''
    pushd python
    python -m build --no-isolation --outdir dist/ --wheel
    python -m installer --prefix $out dist/*.whl
    popd
  '';

  doCheck = true;

  meta = with lib; {
    description = "Open-source braille translator and back-translator";
    homepage = "https://liblouis.io/";
    license = with licenses; [
      lgpl21Plus # library
      gpl3Plus # tools
    ];
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
})
