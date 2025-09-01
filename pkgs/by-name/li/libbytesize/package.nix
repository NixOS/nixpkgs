{
  lib,
  autoreconfHook,
  docbook_xml_dtd_43,
  docbook_xsl,
  fetchFromGitHub,
  gettext,
  gmp,
  gtk-doc,
  libxslt,
  mpfr,
  pcre2,
  pkg-config,
  python3Packages,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbytesize";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "libbytesize";
    rev = finalAttrs.version;
    hash = "sha256-scOnucn7xp6KKEtkpwfyrdzcntJF2l0h0fsQotcceLc=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_43
    docbook_xsl
    gettext
    gtk-doc
    libxslt
    pkg-config
    python3Packages.python
  ];

  nativeInstallCheckInputs = [
    python3Packages.pythonImportsCheckHook
  ];

  buildInputs = [
    gmp
    mpfr
    pcre2
  ];

  doInstallCheck = true;
  strictDeps = true;

  postInstall = ''
    substituteInPlace $out/${python3Packages.python.sitePackages}/bytesize/bytesize.py \
      --replace-fail 'CDLL("libbytesize.so.1")' "CDLL('$out/lib/libbytesize.so.1')"

    # Force compilation of .pyc files to make them deterministic
    ${python3Packages.python.pythonOnBuildForHost.interpreter} -m compileall $out/${python3Packages.python.sitePackages}/bytesize
  '';

  pythonImportsCheck = [ "bytesize" ];

  meta = {
    homepage = "https://github.com/storaged-project/libbytesize";
    description = "Tiny library providing a C 'class' for working with arbitrary big sizes in bytes";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "bscalc";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
