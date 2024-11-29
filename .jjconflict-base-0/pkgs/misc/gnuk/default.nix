{
  lib,
  stdenv,
  fetchFromGitLab,
  gcc-arm-embedded,
  binutils-arm-embedded,
  makeWrapper,
  python3Packages,

  # Default FSIJ IDs
  vid ? "234b",
  pid ? "0000",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnuk";
  version = "2.2";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "gnuk-team";
    repo = "gnuk/gnuk";
    rev = "release/${finalAttrs.version}";
    hash = "sha256-qY/dwkcPJiPx/+inSxH7w7a0v3cWUQDX+NYJwUjnkMY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc-arm-embedded
    binutils-arm-embedded
    makeWrapper
  ];

  buildInputs = with python3Packages; [
    python
    pyusb
    colorama
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  configureFlags = [ "--vidpid=${vid}:${pid}" ];

  # TODO: Check how many of these patches are actually needed.
  installPhase = ''
    mkdir -p $out/bin

    find . -name gnuk.bin -exec cp {} $out \;

    #sed -i 's,Exception as e,IOError as e,' ../tool/stlinkv2.py
    sed -i ../tool/stlinkv2.py \
      -e "1a import array" \
      -e "s,\(data_received =\) (),\1 array.array('B'),g" \
      -e "s,\(data_received\) = data_received + \(.*\),\1.extend(\2),g"
    cp ../tool/stlinkv2.py $out/bin/stlinkv2
    wrapProgram $out/bin/stlinkv2 --prefix PYTHONPATH : "$PYTHONPATH"

    # Some useful helpers
    echo "#! ${stdenv.shell} -e" | tee $out/bin/{unlock,flash}
    echo "$out/bin/stlinkv2 -u \$@" >> $out/bin/unlock
    echo "$out/bin/stlinkv2 -b \$@ $out/gnuk.bin" >> $out/bin/flash
    chmod +x $out/bin/{unlock,flash}
  '';

  meta = {
    homepage = "https://www.fsij.org/category/gnuk.html";
    description = "Implementation of USB cryptographic token for gpg";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    broken = true; # Needs Picolib, which is not packaged in Nixpkgs.
  };
})
