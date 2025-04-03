{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch,
  bash,
  makeWrapper,
  bc,
  jq,
  coreutils,
  util-linux,
  wimlib,
  file,
  syslinux,
  busybox,
  gnugrep, # We can't use busybox's 'grep' as it doesn't support perl '-P' expressions.
}:

stdenvNoCC.mkDerivation rec {
  pname = "bootiso";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "jsamr";
    repo = "bootiso";
    rev = "v${version}";
    sha256 = "1l09d543b73r0wbpsj5m6kski8nq48lbraq1myxhidkgl3mm3d5i";
  };

  patches = [
    (fetchpatch {
      url = "https://code.opensuse.org/package/bootiso/raw/3799710e3da40c1b429ea1a2ce3896d18d08a5c5/f/syslinux-lib-root.patch";
      sha256 = "sha256-x2EJppQsPPymSrjRwEy7mylW+2OKcGzKsKF3y7fzrB8=";
    })
  ];

  strictDeps = true;
  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postPatch = ''
    substituteInPlace bootiso \
      --replace "\$(basename \"\$0\")" "bootiso" \
      --replace "/usr/share/syslinux" "${syslinux}/share/syslinux"
  '';

  postInstall = ''
    wrapProgram $out/bin/bootiso \
      --prefix PATH : ${
        lib.makeBinPath [
          bc
          jq
          coreutils
          util-linux
          wimlib
          file
          syslinux
          gnugrep
          busybox
        ]
      } \
  '';

  meta = with lib; {
    description = "Script for securely creating a bootable USB device from one image file";
    homepage = "https://github.com/jsamr/bootiso";
    license = licenses.gpl3;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.all;
    mainProgram = "bootiso";
  };
}
