{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
  windows,

  # for passthru.tests
  aria2,
  curl,
  libgit2,
  mc,
  vlc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libssh2";
  version = "1.11.1";

  src = fetchurl {
    url = "https://www.libssh2.org/download/libssh2-${finalAttrs.version}.tar.gz";
    hash = "sha256-2ex2y+NNuY7sNTn+LImdJrDIN8s+tGalaw8QnKv2WPc=";
  };

  patches = [
    # https://github.com/libssh2/libssh2/commit/256d04b60d80bf1190e96b0ad1e91b2174d744b1
    ./CVE-2026-7598.patch

    # backport of https://github.com/libssh2/libssh2/commit/2dae3024897e1898d389835151f4e9606227721d
    (fetchurl {
      name = "CVE-2025-15661.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/1d4906e6ebe85a9da2931ba33677ead96a61f07f/debian/patches/CVE-2025-15661.patch";
      hash = "sha256-Rz6i/881CbObUDcZbcPlgVPaKizSp6ZRTdmJNJ9HLHE=";
    })

    # backport of https://github.com/libssh2/libssh2/commit/17626857d20b3c9a1addfa45979dadcee1cd84a4
    (fetchurl {
      name = "CVE-2026-55199.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/1d4906e6ebe85a9da2931ba33677ead96a61f07f/debian/patches/CVE-2026-55199.patch";
      hash = "sha256-AFZa5kohha62aE0if5ckmAdJ0TZNcjfP32yDznoEhNo=";
    })

    # backport of https://github.com/libssh2/libssh2/commit/97acf3dfda80c91c3a8c9f2372546301d4a1a7a8
    (fetchurl {
      name = "CVE-2026-55200.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/1d4906e6ebe85a9da2931ba33677ead96a61f07f/debian/patches/CVE-2026-55200.patch";
      hash = "sha256-wCAglr8BsBWIhnh3SiFeyKzZmIp8rC5MVfFgoEzp/hE=";
    })

    # necessary for the fix for CVE-2026-15661
    (fetchurl {
      name = "libssh-unconst-backport.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/1d4906e6ebe85a9da2931ba33677ead96a61f07f/debian/patches/libssh-unconst-backport.patch";
      hash = "sha256-jc01Fb70GbaD9+RYeSjRaLFBtKLiMPTMuXas21aC0Ag=";
    })

    # https://github.com/libssh2/libssh2/issues/1925#issuecomment-4938515829
    # backport of https://github.com/libssh2/libssh2/commit/34497525929b9a47f03dfb81887ac896202b7e12
    (fetchurl {
      name = "CVE-2026-58050.patch";
      url = "https://raw.githubusercontent.com/JuliaPackaging/Yggdrasil/9404aa5dd96c945a790c425a5f49af19ed2a93b0/L/LibSSH2/LibSSH2%401.11/bundled/patches/CVE-2026-58050-3449752.patch";
      hash = "sha256-BZ1ewZgrroev2gkJwdoHCMFJK4wiRmA/Y4tzwaQqBd8=";
    })

    # backport of https://github.com/libssh2/libssh2/commit/a9758da45a52bc8c630ec9493804d0c6ea30b24a
    (fetchurl {
      name = "CVE-2026-58051.patch";
      url = "https://github.com/JuliaPackaging/Yggdrasil/raw/9404aa5dd96c945a790c425a5f49af19ed2a93b0/L/LibSSH2/LibSSH2%401.11/bundled/patches/CVE-2026-58051-a9758da.patch";
      hash = "sha256-fduXIH02uwzqWV2RDidZmaDBy51V8yuC4XKlGYacjxg=";
    })

    # backport of https://github.com/libssh2/libssh2/commit/5e4776146552d898b9c0e1b313cd093fa8dc92d0
    (fetchurl {
      name = "CVE-2026-66032.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/fe2e3c0848f8501bf729d61790360761a20c75f2/debian/patches/CVE-2026-66032.patch";
      hash = "sha256-H6VXhVc7uCFxj/k3Xouyg+8GYpsn/9IecXZrPkzsgks=";
    })

    # backport of https://github.com/libssh2/libssh2/commit/a2ed82d40964bbc0d64cd717aa0a5a892117d2e6
    (fetchurl {
      name = "CVE-2026-66033.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/fe2e3c0848f8501bf729d61790360761a20c75f2/debian/patches/CVE-2026-66033.patch";
      hash = "sha256-To2ul9ibaAkn0BWNu7fUbpaqHqEX+juUsBbjA0BGF6s=";
    })

    # backport of https://github.com/libssh2/libssh2/commit/a13bb6c773f0d55ad1628cede57e99803cd898d9
    (fetchurl {
      name = "CVE-2026-66034.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/fe2e3c0848f8501bf729d61790360761a20c75f2/debian/patches/CVE-2026-66034.patch";
      hash = "sha256-xYg9qh87KlExI38snAq5E5hF51mIoaJ1wOX9e1uEdmk=";
    })

    # backport of https://github.com/libssh2/libssh2/commit/42e33d81577ed4b95d4b4f6f845e5ee8efe5eeb4
    (fetchurl {
      name = "CVE-2026-66035.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/fe2e3c0848f8501bf729d61790360761a20c75f2/debian/patches/CVE-2026-66035.patch";
      hash = "sha256-+Wr9dp+g347pgKaJYRNRx+EXHA3iOKgOO4tjxi7zkD8=";
    })
  ];

  # this could be accomplished by updateAutotoolsGnuConfigScriptsHook, but that causes infinite recursion
  # necessary for FreeBSD code path in configure
  postPatch = ''
    substituteInPlace ./config.guess --replace-fail /usr/bin/uname uname
  '';

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  propagatedBuildInputs = [ openssl ]; # see Libs: in libssh2.pc
  buildInputs = [ zlib ] ++ lib.optional stdenv.hostPlatform.isMinGW windows.mingw_w64;

  passthru.tests = {
    inherit
      aria2
      libgit2
      mc
      vlc
      ;
    curl = (curl.override { scpSupport = true; }).tests.withCheck;
  };

  meta = {
    description = "Client-side C library implementing the SSH2 protocol";
    homepage = "https://www.libssh2.org";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
  };
})
