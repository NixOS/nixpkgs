{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, coreutils
, poco
, libpng
, libcap
, libtool
, automake
, autoconf
, pkg-config
, python3
, zstd
, cppunit
, pam
, libreoffice-collabora-unwrapped
, #libreoffice-collabora,
  openssl
, nodePackages
, pixman
, cairo
, pango
, rsync # the install script uses it to copy files... this should be patched out
, ...
}:
let
  inherit (lib) getDev getLib optional optionalString;
  gcc_major_version = lib.versions.major stdenv.cc.cc.version;
in
stdenv.mkDerivation rec {
  pname = "collabora-online-developer-edition";
  version = "1.1.9";
  src = fetchFromGitHub {
    owner = "CollaboraOnline";
    repo = "online";
    rev = "helm-collabora-online-${version}";
    hash = "sha256-0gjrNa8qrve8tWjBTf7uwHm8Sb080VdnmsjGSlbDgVw=";
  };
  nativeBuildInputs = [ automake autoconf pkg-config libtool libcap coreutils nodePackages.nodejs (python3.withPackages (ps: with ps; [ lxml polib ])) rsync ];

  buildInputs = [ libpng zstd cppunit pam openssl pixman cairo pango ];
  configureFlags = [
    "--with-vendor=NixOS"
    "--enable-silent-rules"
    "--with-lokit-path=${getDev libreoffice-collabora-unwrapped}/include"
    "--with-lo-path=${libreoffice-collabora-unwrapped}"
    "--with-poco-includes=${getDev poco}/include"
    "--with-poco-libs=${poco}/lib"
    #"--disable-setcap"
    "--disable-dependency-tracking" # speeds up one time builds
  ];
  preConfigure =
    ''
      sed -i -e "s@/usr/bin/env python3@python3@g" configure.ac
      # setcap still needed
      export SETCAP=${libcap}/bin/setcap
    ''
    + optionalString (lib.versionAtLeast gcc_major_version "8") ''
      substituteInPlace configure.ac --replace '-lstdc++fs' "-l${getLib stdenv.cc.cc}/lib/libstdc++fs.la"
      substituteInPlace browser/npm-shrinkwrap.json.in --replace '  "lockfileVersion": 1,' '  "lockfileVersion": 3,'
    ''
    + ''
      patchShebangs .
      ls autogen.sh
      ./autogen.sh
    '';
  postConfigure = ''
    cp -rl browser/archived-packages browser/node_shrinkwrap
    #cp -rl browser/npm-shrinkwrap.json  browser/package-lock.json
  '';
  enableParallelBuilding = true;
  npm_dependenicies_full = buildNpmPackage {
    dontNpmBuild = true;
    pname = "browser";
    version = "1.0";
    src = "${src}/browser";
    npmDepsHash = "sha256-BpjBLSEcfn8e0xcLdwLbRM4xAOR9iBd0qOtVAvjLbhQ=";
    patches = [ ./patches/0002.package-lock-update.diff ];
    postPatch = ''
      cp -rl npm-shrinkwrap.json.in package-lock.json
      cp -rl archived-packages node_shrinkwrap
      substituteInPlace package-lock.json --replace '"lockfileVersion": 1,' '"lockfileVersion": 3,'
    '';
    inherit buildInputs nativeBuildInputs;
    doBuild = false;
    dontNpmPrune = true;
    buildPhase = " ";
  };

  preBuild = ''
    ln -s ${npm_dependenicies_full}/lib/node_modules/cool/node_modules browser/node_modules
  '';
  makeFlags = [
    "MINIFY=true" # To minify our bundle.js and admin-bundle.js passing a MINIFY=true flag to 'make' will minify it. This can be helpful in production
    "DEBUG=true" # To build with debug-info, i.e with sourcemaps
  ];
  doCheck = false;

  #postInstall = ''
  #  ln -s $out/share/coolwsd/browser $out/bin/browser
  #  ln -s $out/share/coolwsd/discovery.xml $out/bin/
  #'';
}
