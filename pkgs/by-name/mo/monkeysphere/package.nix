{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  perl,
  libassuan,
  libgcrypt,
  perlPackages,
  lockfileProgs,
  gnupg,
  coreutils,
  # For the tests:
  openssh,
  which,
  socat,
  cpio,
  hexdump,
  procps,
  openssl,
}:

let
  # A patch is needed to run the tests inside the Nix sandbox:
  # /etc/passwd: "nixbld:x:1000:100:Nix build user:/build:/noshell"
  # sshd: "User nixbld not allowed because shell /noshell does not exist"
  opensshUnsafe = openssh.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [ ./openssh-nixos-sandbox.patch ];
  });
in
stdenv.mkDerivation rec {
  pname = "monkeysphere";
  version = "0.44";

  # The patched OpenSSH binary MUST NOT be used (except in the check phase):
  disallowedRequisites = [ opensshUnsafe ];

  src = fetchurl {
    url = "http://archive.monkeysphere.info/debian/pool/monkeysphere/m/monkeysphere/monkeysphere_${version}.orig.tar.gz";
    sha256 = "1ah7hy8r9gj96pni8azzjb85454qky5l17m3pqn37854l6grgika";
  };

  patches = [ ./monkeysphere.patch ];

  postPatch = ''
    sed -i "s,/usr/bin/env,${coreutils}/bin/env," src/share/ma/update_users
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    perl
    libassuan
    libgcrypt
  ]
  ++ lib.optional doCheck (
    [
      gnupg
      opensshUnsafe
      which
      socat
      cpio
      hexdump
      procps
      lockfileProgs
    ]
    ++ (with perlPackages; [
      CryptOpenSSLRSA
      CryptOpenSSLBignum
    ])
  );

  makeFlags = [
    "PREFIX=/"
    "DESTDIR=$(out)"
  ];

  # The tests should be run (and succeed) when making changes to this package
  # but they aren't enabled by default because they "drain" entropy (GnuPG
  # still uses /dev/random).
  doCheck = false;
  preCheck = lib.optionalString doCheck ''
    patchShebangs tests/
    patchShebangs src/
    sed -i \
      -e "s,/usr/sbin/sshd,${opensshUnsafe}/bin/sshd," \
      -e "s,/bin/true,${coreutils}/bin/true," \
      -e "s,/bin/false,${coreutils}/bin/false," \
      -e "s,openssl\ req,${openssl}/bin/openssl req," \
      tests/basic
    sed -i "s/<(hd/<(hexdump/" tests/keytrans
  '';

  postFixup =
    let
      wrapperArgs =
        runtimeDeps:
        "--prefix PERL5LIB : "
        + (
          with perlPackages;
          makePerlPath [
            # Optional (only required for keytrans)
            CryptOpenSSLRSA
            CryptOpenSSLBignum
          ]
        )
        + lib.optionalString (
          builtins.length runtimeDeps > 0
        ) " --prefix PATH : ${lib.makeBinPath runtimeDeps}";
      wrapMonkeysphere =
        runtimeDeps: program: "wrapProgram $out/bin/${program} ${wrapperArgs runtimeDeps}\n";
      wrapPrograms = runtimeDeps: programs: lib.concatMapStrings (wrapMonkeysphere runtimeDeps) programs;
    in
    wrapPrograms [ gnupg ] [ "monkeysphere-authentication" "monkeysphere-host" ]
    + wrapPrograms [ gnupg lockfileProgs ] [ "monkeysphere" ]
    + ''
      # These 4 programs depend on the program name ($0):
      for program in openpgp2pem openpgp2spki openpgp2ssh pem2openpgp; do
        rm $out/bin/$program
        ln -sf keytrans $out/share/monkeysphere/$program
        makeWrapper $out/share/monkeysphere/$program $out/bin/$program \
          ${wrapperArgs [ ]}
      done
    '';

  meta = with lib; {
    homepage = "http://web.monkeysphere.info/";
    description = "Leverage the OpenPGP web of trust for SSH and TLS authentication";
    longDescription = ''
      The Monkeysphere project's goal is to extend OpenPGP's web of
      trust to new areas of the Internet to help us securely identify
      servers we connect to, as well as each other while we work online.
      The suite of Monkeysphere utilities provides a framework to
      transparently leverage the web of trust for authentication of
      TLS/SSL communications through the normal use of tools you are
      familiar with, such as your web browser0 or secure shell.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
