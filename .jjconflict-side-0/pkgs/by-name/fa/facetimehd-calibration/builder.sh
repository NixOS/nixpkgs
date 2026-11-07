# Described on https://github.com/patjak/facetimehd/wiki/Extracting-the-sensor-calibration-files
#
# The whole download is 518MB; the deflate stream we're interested in is 1.2MB.
urlRoot="https://download.info.apple.com/Mac_OS_X/031-30890-20150812-ea191174-4130-11e5-a125-930911ba098f"
curl --insecure -o bootcamp.zip "$urlRoot/bootcamp$version.zip" -r 2338085-3492508

# Add appropriate headers and footers so that zcat extracts cleanly

{ printf '\x1f\x8b\x08\x00\x00\x00\x00\x00\x00\x00'
  cat bootcamp.zip
  printf '\x51\x1f\x86\x78\xcf\x5b\x12\x00'
} | zcat > AppleCamera64.exe
unrar x AppleCamera64.exe AppleCamera.sys

# These offsets and sizes are from the wiki also
dd bs=1 skip=1663920 count=33060 if=AppleCamera.sys of=9112_01XX.dat
dd bs=1 skip=1644880 count=19040 if=AppleCamera.sys of=1771_01XX.dat
dd bs=1 skip=1606800 count=19040 if=AppleCamera.sys of=1871_01XX.dat
dd bs=1 skip=1625840 count=19040 if=AppleCamera.sys of=1874_01XX.dat

mkdir -p "$out/lib/firmware/facetimehd"
cp -a *.dat "$out/lib/firmware/facetimehd"
