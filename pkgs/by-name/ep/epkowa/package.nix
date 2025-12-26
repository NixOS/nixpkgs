{
  lib,
  stdenv,
  callPackages,
  fetchurl,
  fetchpatch,
  makeWrapper,
  symlinkJoin,
  pkg-config,
  libtool,
  gtk2,
  libxml2,
  libxslt,
  libusb-compat-0_1,
  sane-backends,
  getopt,
  epkowa,
  plugins ? epkowa.plugins,
}:
let
  common_meta = {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; epson;
    platforms = with lib.platforms; linux;
  };
  plugins' = lib.attrsets.filterAttrs (_: lib.isDerivation) plugins;
in
let
  fwdir = symlinkJoin {
    name = "esci-firmware-dir";
    paths = lib.mapAttrsToList (name: value: value + "/share/esci") plugins';
  };
in
let
  iscan-data = stdenv.mkDerivation rec {
    pname = "iscan-data";
    version = "1.39.2-1";

    src = fetchurl {
      urls = [
        "http://support.epson.net/linux/src/scanner/iscan/iscan-data_${version}.tar.gz"
        "https://web.archive.org/web/http://support.epson.net/linux/src/scanner/iscan/iscan-data_${version}.tar.gz"
      ];
      sha256 = "092qhlnjjgz11ifx6mng7mz20i44gc0nlccrbmw18xr5hipbqqka";
    };

    buildInputs = [
      libxslt
    ];

    meta = common_meta;
  };
in
stdenv.mkDerivation rec {
  pname = "iscan";
  version = "2.30.4-2";

  src = fetchurl {
    urls = [
      "http://support.epson.net/linux/src/scanner/iscan/iscan_${version}.tar.gz"
      "https://web.archive.org/web/http://support.epson.net/linux/src/scanner/iscan/iscan_${version}.tar.gz"
    ];
    sha256 = "1ma76jj0k3bz0fy06fiyl4di4y77rcryb0mwjmzs5ms2vq9rjysr";
  };

  nativeBuildInputs = [
    pkg-config
    libtool
    makeWrapper
  ];
  buildInputs = [
    gtk2
    libxml2
    libusb-compat-0_1
    sane-backends
  ];

  patches = [
    # Patch for compatibility with libpng versions greater than 10499
    (fetchpatch {
      urls = [
        "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/iscan/files/iscan-2.28.1.3+libpng-1.5.patch?h=b6e4c805d53b49da79a0f64ef16bb82d6d800fcf"
        "https://web.archive.org/web/https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/iscan/files/iscan-2.28.1.3+libpng-1.5.patch?h=b6e4c805d53b49da79a0f64ef16bb82d6d800fcf"
      ];
      sha256 = "04y70qjd220dpyh771fiq50lha16pms98mfigwjczdfmx6kpj1jd";
    })
    # Patch iscan to search appropriate folders for firmware files
    ./firmware_location.patch
    # Patch deprecated use of sscanf code to use a more modern C99 compatible version
    ./sscanf.patch
  ];
  patchFlags = [ "-p0" ];

  configureFlags = [
    "--enable-dependency-reduction"
    "--disable-frontend"
  ];

  postConfigure = ''
    echo '#define NIX_ESCI_PREFIX "'${fwdir}'"' >> config.h
  '';

  postInstall = ''
    mkdir -p $out/etc/sane.d
    cp backend/epkowa.conf $out/etc/sane.d
    echo "epkowa" > $out/etc/sane.d/dll.conf
    ln -s ${iscan-data}/share/iscan-data $out/share/iscan-data
    mkdir -p $out/lib/iscan
  ''
  + lib.optionalString (plugins' ? network) ''
    ln -s ${plugins'.network}/lib/iscan/network $out/lib/iscan/network
  '';
  postFixup = ''
    # iscan-registry is a shell script requiring getopt
    wrapProgram $out/bin/iscan-registry --prefix PATH : ${getopt}/bin
    registry=$out/bin/iscan-registry;
  ''
  + lib.concatStrings (
    lib.mapAttrsToList (name: value: ''
      plugin=${value};
      ${value.passthru.registrationCommand}
    '') plugins'
  );

  passthru.plugins = callPackages ./plugins.nix { inherit common_meta; };

  meta = common_meta // {
    description = "sane-epkowa backend for some epson scanners";
    longDescription = ''
      Includes gui-less iscan (aka. Image Scan! for Linux).
      Supported hardware: at least :
    ''
    + lib.concatStringsSep ", " (lib.mapAttrsToList (name: value: value.passthru.hw) plugins')
    + ''
      It is possible to only use a subset of the plugins by overriding the `plugins` input:
      epkowa' = pkgs.epkowa.override {
        plugins = {
          inherit (pkgs.epkowa.plugins) x770; # Select correct plugins for your scanner here
        };
      };
    '';
    maintainers = with lib.maintainers; [
      symphorien
      dominikh
    ];
  };
}
