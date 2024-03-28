{ lib
, stdenv
, fxload
, coreutils
, fetchurl
,
}:
stdenv.mkDerivation rec {
  pname = "qhyccd_sdk";
  version = "23.09.06";
  linux64Sha256 = "17ayxxf5wk2k14jyry3c5m5mwnyh9r0ykyh8iaxdlsk9dzjw0chp";
  arm64Sha256 = "1ag70zpzqp6dp0rvz974vsnfyll7jvwq69s1hai3v2chvywllhs5";

  dontConfigure = true;
  dontPatch = true;
  dontPatchELF = true;

  strippedVersion = builtins.replaceStrings [ "." ] [ "" ] version;

  archSuffix =
    {
      aarch64-linux = "Arm64";
      x86_64-linux = "linux64";
    }.${stdenv.system}
      or (throw "Unsupported system: ${stdenv.system}");

  archSha256 =
    if stdenv.system == "aarch64-linux"
    then arm64Sha256
    else linux64Sha256;

  src = fetchurl {
    url = "https://www.qhyccd.com/file/repository/publish/SDK/${strippedVersion}/sdk_${archSuffix}_${version}.tgz";
    sha256 = archSha256;
  };

  buildPhase = ''
    chmod +x ./install.sh

    mkdir -p $out/sbin

    substituteInPlace ./install.sh \
      --replace /lib/udev $out/lib/udev \
      --replace /etc/udev $out/etc/udev \
      --replace "cp -a sbin/fxload" "# cp -a /sbin/fxload" \
      --replace /usr/local $out/usr/local \
      --replace /lib/firmware $out/lib/firmware \
      --replace /usr/share/usb $out/usr/share/usb \
      --replace /usr $out/usr \
      --replace ldconfig '# ldconfig'

      # udev rules requires
      # services.udev.packages = [ pkgs.qhyccd_sdk ];
    substituteInPlace ./lib/udev/rules.d/85-qhyccd.rules ./etc/udev/rules.d/85-qhyccd.rules \
      --replace /lib/firmware/qhy $out/lib/firmware/qhy \
      --replace /sbin/fxload $out/sbin/fxload \
      --replace "-D \$env{DEVNAME}" "-d \$env{ID_VENDOR_ID}:\$env{ID_MODEL_ID}" \
      --replace /bin/sleep ${coreutils}/bin/sleep
  '';

  installPhase = ''
    ln -s ${fxload}/bin/fxload $out/sbin/fxload
    source ./install.sh
  '';

  meta = with lib; {
    homepage = "https://www.qhyccd.com/html/prepub/log_en.html";
    description = "A software development kit for interfacing with QHYCCD astronomy cameras, including libraries and sample code";
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = with maintainers; [ realsnick ];
  };
}
