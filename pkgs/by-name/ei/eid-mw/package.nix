{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  makeBinaryWrapper,
  pkg-config,
  replaceVarsWith,
  curl,
  gtk3,
  libassuan,
  libbsd,
  libproxy,
  libxml2,
  nssTools,
  openssl,
  p11-kit,
  pcsclite,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eid-mw";
  # NOTE: Don't just blindly update to the latest version/tag. Releases are always for a specific OS.
  version = "5.1.26";

  src = fetchFromGitHub {
    owner = "Fedict";
    repo = "eid-mw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1dswXwXNTN3006KHnqlVntg6uHMxNe7NQ4BdKAB2FXM=";
  };

  postPatch = ''
    sed 's@m4_esyscmd_s(.*,@[${finalAttrs.version}],@' -i configure.ac
    substituteInPlace configure.ac \
      --replace-fail 'p11kitcfdir=""' 'p11kitcfdir="'$out/share/p11-kit/modules'"'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    libassuan
    makeBinaryWrapper
    openssl
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    curl
    gtk3
    libbsd
    libproxy
    libxml2
    p11-kit
    pcsclite
  ];

  preConfigure = ''
    mkdir openssl
    ln -s ${lib.getLib openssl}/lib openssl
    ln -s ${openssl.bin}/bin openssl
    ln -s ${openssl.dev}/include openssl
    export SSL_PREFIX=$(realpath openssl)
  '';

  # pinentry uses hardcoded `/usr/bin/pinentry`, so use the built-in (uglier) dialogs for pinentry.
  configureFlags = [ "--disable-pinentry" ];

  postInstall =
    let
      eid-nssdb-in = replaceVarsWith {
        isExecutable = true;
        src = ./eid-nssdb.in;
        replacements = {
          inherit (stdenv) shell;
        };
      };
    in
    ''
      install -D ${eid-nssdb-in} $out/bin/eid-nssdb
      substituteInPlace $out/bin/eid-nssdb \
        --replace-fail "modutil" "${lib.getExe' nssTools "modutil"}"

      rm $out/bin/about-eid-mw
      wrapProgram $out/bin/eid-viewer \
        --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/$name"
    '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Belgian electronic identity card (eID) middleware";
    homepage = "https://eid.belgium.be/en";
    license = lib.licenses.lgpl3Only;
    longDescription = ''
      Allows user authentication and digital signatures with Belgian ID cards.
      Also requires a running pcscd service and compatible card reader.

      eid-viewer is also installed.

      This package only installs the libraries. To use eIDs in Firefox or
      Chromium, the eID Belgium add-on must be installed.
      This package only installs the libraries. To use eIDs in NSS-compatible
      browsers like Chrom{e,ium} or Firefox, each user must first execute:
        ~$ eid-nssdb add
      (Running the script once as root with the --system option enables eID
      support for all users, but will *not* work when using Chrom{e,ium}!)
      Before uninstalling this package, it is a very good idea to run
        ~$ eid-nssdb [--system] remove
      and remove all ~/.pki and/or /etc/pki directories no longer needed.

      The above procedure doesn't seem to work in Firefox. You can override the
      firefox wrapper to add this derivation to the PKCS#11 modules, like so:

          firefox.override { pkcs11Modules = [ pkgs.eid-mw ]; }
    '';
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bfortz
      chvp
    ];
  };
})
