{
  stdenv,
  lib,
  fetchurl,
  dpkg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mlxbf-bootimages";
  version = "4.14.0-13878";

  src = fetchurl {
    url = "https://linux.mellanox.com/public/repo/doca/3.3.0-${finalAttrs.version}/ubuntu24.04/arm64/mlxbf-bootimages-signed_${finalAttrs.version}_arm64.deb";
    hash = "sha256-CeUjmyU1kfsQWNFm/EN3arF7t8lM1o7p9oF7DqeiCnk=";
  };

  nativeBuildInputs = [
    dpkg
  ];

  unpackCmd = "dpkg -x $curSrc src";

  # Only install /lib. /usr only contains the licenses which are also available
  # in /lib.
  installPhase = ''
    find lib -type f -exec install -D {} $out/{} \;
  '';

  meta = {
    description = "BlueField boot images";
    homepage = "https://github.com/Mellanox/bootimages";
    # It is unclear if the bootimages themselves are Open Source software. They
    # never explicitly say they are. They contain Open Source software licensed
    # under bsd2, bsd2Patent, bsd3. However, it is probably safer to assume
    # they are unfree. See https://github.com/Mellanox/bootimages/issues/3
    license = lib.licenses.unfree;
    platforms = [ "aarch64-linux" ];
    maintainers = with lib.maintainers; [
      nikstur
      thillux
    ];
  };
})
