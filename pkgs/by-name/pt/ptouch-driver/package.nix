{ lib
, stdenv
, fetchFromGitHub
, cups
, cups-filters
, foomatic-db-engine
, fetchpatch
, ghostscript
, libpng
, libxml2
, autoreconfHook
, perl
, patchPpdFilesHook
}:

stdenv.mkDerivation rec {
  pname = "ptouch-driver";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "philpem";
    repo = "printer-driver-ptouch";
    rev = "v${version}";
    hash = "sha256-3ZotSHn7lERp53hAzx47Ct/k565rEoensCcltwX/Xls=";
  };

  patches = [
    # Fixes some invalid XML file that otherwise causes a build failure
    (fetchpatch {
      name = "fix-brother-ql-600.patch";
      url = "https://github.com/philpem/printer-driver-ptouch/commit/b3c53b3bc4dd98ed172f2c79405c7c09b3b3836a.patch";
      hash = "sha256-y5bHKFeRXx8Wdl1++l4QNGgiY41LY5uzrRdOlaZyF9I=";
    })
  ];

  buildInputs = [ cups cups-filters ghostscript libpng libxml2 ];
  nativeBuildInputs = [
    autoreconfHook
    foomatic-db-engine
    patchPpdFilesHook
    (perl.withPackages (pp: with pp; [ XMLLibXML ]))
  ];

  postPatch = ''
    patchShebangs ./foomaticalize
  '';

  postInstall = ''
    export FOOMATICDB="${placeholder "out"}/share/foomatic"
    mkdir -p "${placeholder "out"}/share/cups/model"
    foomatic-compiledb -j "$NIX_BUILD_CORES" -d "${placeholder "out"}/share/cups/model/ptouch-driver"
  '';

  # compress ppd files
  postFixup = ''
    echo 'compressing ppd files'
    find -H "${placeholder "out"}/share/cups/model/ptouch-driver" -type f -iname '*.ppd' -print0  \
      | xargs -0r -n 4 -P "$NIX_BUILD_CORES" gzip -9n
  '';

  # Comments indicate the respective
  # package the command is contained in.
  ppdFileCommands = [
    "rastertoptch" # ptouch-driver
    "gs" # ghostscript
    "foomatic-rip" # cups-filters
  ];

  meta = with lib; {
    changelog = "https://github.com/philpem/printer-driver-ptouch/releases/tag/v${version}";
    description = "Printer Driver for Brother P-touch and QL Label Printers";
    downloadPage = "https://github.com/philpem/printer-driver-ptouch";
    homepage = "https://github.com/philpem/printer-driver-ptouch";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sascha8a ];
    platforms = platforms.linux;
    longDescription = ''
      This is ptouch-driver, a printer driver based on CUPS and foomatic,
      for the Brother P-touch and QL label printer families.
    '';
  };
}
