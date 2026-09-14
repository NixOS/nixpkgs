{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  docbook_xsl,
  docbook_xml_dtd_43,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  libidn2,
  libunistring,
  libxslt,
  publicsuffix-list,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpsl";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "rockdaboot";
    repo = "libpsl";
    tag = finalAttrs.version;
    hash = "sha256-Me22tepjCn1IvILw/Q286QemXs+B5q/h8xxtUs6bLss=";
  };

  outputs = [
    "out"
    "dev"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook_xsl
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libidn2
    libunistring
    libxslt
  ];

  strictDeps = true;

  propagatedBuildInputs = [
    publicsuffix-list
  ];

  mesonFlags = [
    (lib.mesonBool "docs" true)
    (lib.mesonOption "psl_distfile" "${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat")
    (lib.mesonOption "psl_file" "${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat")
    (lib.mesonOption "psl_testfile" "${publicsuffix-list}/share/publicsuffix/test_psl.txt")
  ];

  # bin/psl-make-dafsa brings a large runtime closure through python3
  # use the libpsl-with-scripts package if you need this
  postInstall = ''
    rm $out/bin/psl-make-dafsa $out/share/man/man1/psl-make-dafsa*
  '';

  enableParallelBuilding = true;

  doCheck = true;

  __structuredAttrs = true;

  meta = {
    description = "C library for the Publix Suffix List";
    longDescription = ''
      libpsl is a C library for the Publix Suffix List (PSL). A "public suffix"
      is a domain name under which Internet users can directly register own
      names. Browsers and other web clients can use it to avoid privacy-leaking
      "supercookies" and "super domain" certificates, for highlighting parts of
      the domain in a user interface or sorting domain lists by site.
    '';
    homepage = "https://rockdaboot.github.io/libpsl/";
    changelog = "https://raw.githubusercontent.com/rockdaboot/libpsl/libpsl-${finalAttrs.version}/NEWS";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "psl";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [ "libpsl" ];
  };
})
