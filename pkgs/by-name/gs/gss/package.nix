{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gtk-doc,
  withShishi ? !stdenv.hostPlatform.isDarwin,
  shishi,
}:

stdenv.mkDerivation rec {
  pname = "gss";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://gnu/gss/gss-${version}.tar.gz";
    hash = "sha256-7M6r3vTK4/znIYsuy4PrQifbpEtTthuMKy6IrgJBnHM=";
  };

  # krb5context test uses certificates that expired on 2024-07-11.
  # Reported to bug-gss@gnu.org with Message-ID: <87cyngavtt.fsf@alyssa.is>.
  postPatch = ''
    rm tests/krb5context.c
  '';

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
  ];

  buildInputs = lib.optional withShishi shishi;

  # ./stdint.h:89:5: error: expected value in expression
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export GNULIBHEADERS_OVERRIDE_WINT_T=0
  '';

  configureFlags = [
    "--${if withShishi then "enable" else "disable"}-kerberos5"
  ];

  # Fixup .la files
  postInstall = lib.optionalString withShishi ''
    sed -i 's,\(-lshishi\),-L${shishi}/lib \1,' $out/lib/libgss.la
  '';

  meta = with lib; {
    homepage = "https://www.gnu.org/software/gss/";
    description = "Generic Security Service";
    mainProgram = "gss";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
