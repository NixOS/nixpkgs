{
  autoreconfHook,
  cairo,
  cppunit,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  libcap,
  libpng,
  libreoffice-collabora,
  nodejs,
  npmHooks,
  pam,
  pango,
  pixman,
  pkg-config,
  poco,
  python3,
  rsync,
  stdenv,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "collabora-online";
  version = "24.04.5-3";

  src = fetchFromGitHub {
    owner = "CollaboraOnline";
    repo = "online";
    rev = "refs/tags/cp-${finalAttrs.version}";
    hash = "sha256-wy+vfRmKYULq2kg0MKhdxTD7HC63cTd1cYX5xN7LYgg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libcap
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    python3
    python3.pkgs.lxml
    python3.pkgs.polib
    rsync
  ];

  buildInputs = [
    cairo
    cppunit
    libpng
    pam
    pango
    pixman
    poco
    zstd
  ];

  configureFlags = [
    "--disable-setcap"
    "--disable-werror"
    "--enable-silent-rules"
    "--with-lo-path=${libreoffice-collabora}/lib/collaboraoffice"
    "--with-lokit-path=${libreoffice-collabora.src}/include"
  ];

  env = {
    SETCAP = "${libcap}/bin/setcap";
  };

  postPatch =
    ''
      cp ${./package-lock.json} ${finalAttrs.npmRoot}/package-lock.json
      patchShebangs .
      substituteInPlace configure.ac --replace-fail '/usr/bin/env python3' python3
      substituteInPlace coolwsd-systemplate-setup --replace-fail /bin/pwd pwd
    ''
    # Use setcap'd wrappers from the wrappers dir, not from the "application path".
    + ''
      substituteInPlace common/JailUtil.cpp --replace-fail \
        'Poco::Path(Util::getApplicationPath(), "coolmount").toString()' \
        'std::string("/run/wrappers/bin/coolmount")'
      substituteInPlace wsd/COOLWSD.cpp --replace-fail \
        ' forKitPath += "coolforkit";' \
        ' forKitPath = "/run/wrappers/bin/coolforkit";'
    ''
    # In the nix build, COOLWSD_VERSION_HASH becomes the same as COOLWSD_VERSION, e.g. `24.04.3.5`.
    # The web server that serves files from `/browser/$COOLWSD_VERSION_HASH`, doesn't expect the
    # hash to contain dots.
    + ''
      substituteInPlace wsd/FileServer.cpp --replace-fail \
        'Poco::RegularExpression gitHashRe("/([0-9a-f]+)/");' \
        'Poco::RegularExpression gitHashRe("/([0-9a-f.]+)/");' \
    '';

  postInstall = ''
    cp etc/ca-chain.cert.pem etc/cert.pem etc/key.pem $out/etc/coolwsd
  '';

  npmDeps = fetchNpmDeps {
    src = null;
    # TODO: Use upstream `npm-shrinkwrap.json` once it's fixed
    # https://github.com/CollaboraOnline/online/issues/9644
    postPatch = ''cp ${./package-lock.json} package-lock.json'';
    hash = "sha256-SoSH9k/bfdxxULy76fqu0LLzEjv8pCil668lapH3m48=";
  };

  npmRoot = "browser";

  passthru = {
    # Used by NixOS module.
    libreoffice = libreoffice-collabora;
  };

  meta = {
    description = "Collaborative online office suite based on LibreOffice technology";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.xzfc ];
    homepage = "https://www.collaboraonline.com";
    platforms = lib.platforms.linux;
  };
})
