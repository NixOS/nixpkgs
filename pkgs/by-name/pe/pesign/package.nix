{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  nss,
  efivar,
  util-linux,
  popt,
  nspr,
  mandoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pesign";
  version = "116";

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "pesign";
    tag = finalAttrs.version;
    hash = "sha256-cuOSD/ZHkilgguDFJviIZCG8kceRWw2JgssQuWN02Do=";
  };

  patches = [
    # fix build with gcc14
    # https://github.com/rhboot/pesign/pull/119
    (fetchpatch2 {
      url = "https://github.com/rhboot/pesign/commit/1f9e2fa0b4d872fdd01ca3ba81b04dfb1211a187.patch?full_index=1";
      hash = "sha256-viVM4Z0jAEAWC3EdJVHcWe21aQskH5XE85lOd6Xd/qU=";
    })
  ];

  # nss-util is missing because it is already contained in nss
  # Red Hat seems to be shipping a separate nss-util:
  # https://centos.pkgs.org/7/centos-x86_64/nss-util-devel-3.44.0-4.el7_7.x86_64.rpm.html
  # containing things we already have in `nss`.
  # We can ignore all the errors pertaining to a missing
  # nss-util.pc I suppose.
  buildInputs = [
    efivar
    util-linux
    nss
    popt
    nspr
    mandoc
  ];
  nativeBuildInputs = [ pkg-config ];

  makeFlags = [ "INSTALLROOT=$(out)" ];

  postInstall = ''
    mv $out/usr/bin $out/bin
    mv $out/usr/share $out/share

    rm -rf $out/usr
    rm -rf $out/etc
    rm -rf $out/run
  '';

  meta = {
    description = "Signing tools for PE-COFF binaries. Compliant with the PE and Authenticode specifications";
    homepage = "https://github.com/rhboot/pesign";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ raitobezarius ];
    # efivar is currently Linux-only.
    platforms = lib.platforms.linux;
  };
})
