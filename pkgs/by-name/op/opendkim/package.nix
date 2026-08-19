{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  autoreconfHook,
  pkg-config,
  makeWrapper,
  libbsd,
  libmilter,
  openssl,
  perl,
  unbound,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opendkim";
  version = "2.11.0-Beta2";

  src = fetchFromGitHub {
    owner = "trusteddomainproject";
    repo = "OpenDKIM";
    tag = "rel-opendkim-${lib.replaceString "." "-" finalAttrs.version}";
    hash = "sha256-/IqWB0s39t8BeqpRIa8MZn4HgXlIMuU2UbYbpZGNo1s=";
  };

  # TODO: remove when is merge
  patches = [
    (fetchpatch {
      # https://github.com/trusteddomainproject/OpenDKIM/pull/288
      name = "CVE-2020-35766.patch";
      url = "https://github.com/trusteddomainproject/OpenDKIM/commit/520338d25af68cf263b97ba63037e3f5856a10da.patch";
      hash = "sha256-O4a4boa67tj0nqxee6V+u7rd3l3RGaiWE+Mu0ib4DWE=";
    })
    (fetchpatch {
      # https://github.com/trusteddomainproject/OpenDKIM/pull/287
      name = "CVE-2022-48521.patch";
      url = "https://github.com/trusteddomainproject/OpenDKIM/commit/e67c33e1a08cca793470e6a6ff44082f73f6d222.patch";
      hash = "sha256-QtxiRM+/NDlQhfGB8XNX1M1PtQyXXarawoF+8pTTMVo=";
    })
    (fetchpatch {
      # https://github.com/trusteddomainproject/OpenDKIM/pull/261
      name = "fix-old-style-dkimf_base64_encode_file.patch";
      url = "https://github.com/trusteddomainproject/OpenDKIM/commit/3f0aa0a31c11b9924f826708535071b68c22b731.patch";
      hash = "sha256-nQCBGef2kjs9ZyHwPreNPQYW6jBOBTDhVq9RyeGSN/Y=";
    })
  ];

  configureFlags = [
    "--with-milter=${libmilter}"
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "--with-unbound=${unbound}";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libbsd
    openssl
    libmilter
    perl
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin unbound;

  postInstall = ''
    wrapProgram $out/sbin/opendkim-genkey \
      --prefix PATH : ${openssl.bin}/bin
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=unstable"
      "--version-regex=rel-opendkim-(\\d+)-(\\d+)-(.*)"
    ];
  };

  meta = {
    description = "C library for producing DKIM-aware applications and an open source milter for providing DKIM service";
    homepage = "http://www.opendkim.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "opendkim";
    maintainers = with lib.maintainers; [ maevii ];
  };
})
