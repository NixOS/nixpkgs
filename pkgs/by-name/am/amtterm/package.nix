{
  fetchFromGitLab,
  fetchpatch,
  lib,
  stdenv,
  makeWrapper,
  glib,
  gnutls,
  gtk3,
  meson,
  ninja,
  perl,
  perlPackages,
  pkg-config,
  vte,
  withGamt ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amtterm";
  version = "1.8";

  buildInputs =
    (with perlPackages; [
      perl
      SOAPLite
    ])
    ++ [
      glib
      gnutls
    ]

    ++ lib.optionals withGamt [
      gtk3
      vte
    ];
  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  src = fetchFromGitLab {
    owner = "kraxel";
    repo = "amtterm";
    tag = "amtterm-${finalAttrs.version}-1";
    hash = "sha256-RedbapQgbtAeUmrz8hwuKeFusl/ePSspOjZxW8XYaag=";
  };

  patches = [
    # In 1.8, plaintext connections fail and gamt ignores -C.
    # https://gitlab.com/kraxel/amtterm/-/merge_requests/3
    (fetchpatch {
      name = "redir-set-connect-error-before-reporting.patch";
      url = "https://gitlab.com/kraxel/amtterm/-/commit/5b79b25a7933ee4b770b892393f695d31cdaa44d.patch";
      hash = "sha256-yJfwJoZPs/NDoETKd032XtozuVyi2+YETRVwmYNRWos=";
    })
    (fetchpatch {
      name = "redir-fix-non-ssl-connections.patch";
      url = "https://gitlab.com/kraxel/amtterm/-/commit/649f0654c598b2e8075a3b9f815fa693f4a171fe.patch";
      hash = "sha256-4GRaSyBVAK2ETM8cz5VaXKWcpzNAVctK9PNDJ1OhxAI=";
    })
    (fetchpatch {
      name = "gamt-use-ssl-when-c-is-given.patch";
      url = "https://gitlab.com/kraxel/amtterm/-/commit/ec2ce0fad989b828c0529b0298d15745987a1092.patch";
      hash = "sha256-NUbaZhi8KqC9CIPwN2GaBZhzz9GCxPKBB2jQT+wz6g8=";
    })
  ];

  postInstall = "wrapProgram $out/bin/amttool --prefix PERL5LIB : $PERL5LIB";

  meta = {
    description = "Intel AMT® SoL client + tools";
    homepage = "https://gitlab.com/kraxel/amtterm";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kallisti-dev ];
    # gamt uses GTK's X11 backend; nixpkgs' gtk3 uses Quartz on Darwin.
    platforms = lib.platforms.linux ++ lib.optionals (!withGamt) lib.platforms.darwin;
  };
})
