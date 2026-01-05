{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
  pam,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gradm";
  version = "3.1-202111052217";

  src = fetchurl {
    url = "https://grsecurity.net/stable/gradm-${finalAttrs.version}.tar.gz";
    hash = "sha256-JFkpDzZ6R8ihzk6i7Ag1l5nqM9wV7UQ2Q5WWzogoT7k=";
  };

  nativeBuildInputs = [
    bison
    flex
    udevCheckHook
  ];

  buildInputs = [ pam ];

  enableParallelBuilding = true;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "LEX=${flex}/bin/flex"
    "MANDIR=/share/man"
    "MKNOD=true"
  ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace "/usr/bin/" "" \
      --replace "/usr/include/security/pam_" "${pam}/include/security/pam_"

    substituteInPlace gradm_defs.h \
      --replace "/sbin/grlearn" "$out/bin/grlearn" \
      --replace "/sbin/gradm" "$out/bin/gradm" \
      --replace "/sbin/gradm_pam" "$out/bin/gradm_pam"

    echo 'inherit-learn /nix/store' >>learn_config

    mkdir -p "$out/etc/udev/rules.d"
  '';

  doInstallCheck = true;

  postInstall = "rmdir $out/dev";

  meta = {
    description = "grsecurity RBAC administration and policy analysis utility";
    homepage = "https://grsecurity.net";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      thoughtpolice
      joachifm
    ];
  };
})
