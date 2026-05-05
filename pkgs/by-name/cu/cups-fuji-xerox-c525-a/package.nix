# cups-fuji-xerox-c525-a.nix
{
  stdenv,
  fetchurl,
  ghostscript,
  pkgs,
  makeWrapper,
  patchelf,
  dpkg,
  lib,
}:
let
  pname = "cups-fuji-xerox-c525-a";
  driverName = "fuji-xerox-docuprint-c525-a-ap";
  version = "1.0-2_i386"; # Updated from deb filename
  deb = "${driverName}_${version}.deb";
in
stdenv.mkDerivation {
  inherit
    pname
    driverName
    version
    deb
    ;

  src = fetchurl {
    name = "${deb}";
    url = "https://archive.org/download/${driverName}_${version}/${deb}";
    sha256 = "058pbqqb7injbabv2g0wz2qsxscmk1ysryccnpcdgjnplh9m32pj";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    patchelf
  ];
  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src $out
    runHook postUnpack
  '';

  installPhase = ''
      mv $out/usr/* $out/
      rmdir $out/usr

      substituteInPlace $out/share/cups/model/FujiXerox/en/FX_DocuPrint_C525_A_AP.ppd --replace-warn "/usr" "$out"
      substituteInPlace $out/lib/cups/filter/FXM_PS2PM --replace-warn "/usr" "${ghostscript}"

      # DYNAMICALLY find all ELF 32-bit executables in lib/cups/filter
    mapfile -t filters < <(find $out/lib/cups/filter -type f -executable -exec sh -c ' file "$1" 2>/dev/null | grep -q "ELF 32-bit" && basename "$1" ' sh {} \;)

    # echo "Found ELF 32-bit filters: ''${filters[*]}"

    # Patch all ELF binaries
      for f in "''${filters[@]}"; do
        patchelf --set-interpreter ${pkgs.pkgsi686Linux.glibc}/lib/ld-linux.so.2 \
        --set-rpath "${
          pkgs.lib.makeLibraryPath (
            with pkgs.pkgsi686Linux;
            [
              glibc
              cups
            ]
          )
        }" "$out/lib/cups/filter/$f"
      done

  '';

  meta = with lib; {
    description = "Fuji Xerox DocuPrint C525 A-AP CUPS driver, also work with Dell 1320c and Xerox Phaser 6125N";
    homepage = "https://archive.org/details/fuji-xerox-docuprint-c525-a-ap_1.0-2_i386";
    license = licenses.unfree; # Proprietary binary driver
    platforms = platforms.linux;
    maintainers = with maintainers; [ isomorph70 ];
    broken = false; # Works on NixOS, with 32 bit libraries.
    # A flaw on Xerox 6525N, printing n copies results in n^2 copies being printed.
  };
}
