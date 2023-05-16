<<<<<<< HEAD
{ lib, stdenv, fetchurl }:

let
  # Upstream versioned download links are broken
  # NOTE: the archive.org timestamp must be updated if the version changes.
  # See https://xenproject.org/downloads/
  files = [
    {
      url = "https://web.archive.org/web/20230817070451if_/https://xenbits.xenproject.org/pvdrivers/win/xenbus.tar";
      hash = "sha256-sInkbVL/xkoUeZxgknLM3e2AXBVSqItF2Vpkon53Xec=";
    }
    {
      url = "https://web.archive.org/web/20230817070811if_/https://xenbits.xenproject.org/pvdrivers/win/xencons.tar";
      hash = "sha256-r8bxH5B4y0V9qgALi42KtpZW05UOevv29AqqXaIXMBo=";
    }
    {
      url = "https://web.archive.org/web/20230817070811if_/https://xenbits.xenproject.org/pvdrivers/win/xenhid.tar";
      hash = "sha256-e7ztzaXi/6irMus9IH0cfbW5HiKSaybXV1C/rd5mEfA=";
    }
    {
      url = "https://web.archive.org/web/20230817071133if_/https://xenbits.xenproject.org/pvdrivers/win/xeniface.tar";
      hash = "sha256-qPM0TjcGR2luPtOSAfXJ22k6yhwJOmOP3ot6kopEFsI=";
    }
    {
      url = "https://web.archive.org/web/20230817071134if_/https://xenbits.xenproject.org/pvdrivers/win/xennet.tar";
      hash = "sha256-Vg1wSfXjIVRd2iXCa19W4Jdaf2LTVin0yac/D70UjPM=";
    }
    {
      url = "https://web.archive.org/web/20230817070811if_/https://xenbits.xenproject.org/pvdrivers/win/xenvbd.tar";
      hash = "sha256-nLNM0TWqsEWiQBCYxARMldvRecRUcY5DBF5DNAG4490=";
    }
    {
      url = "https://web.archive.org/web/20230817071225if_/https://xenbits.xenproject.org/pvdrivers/win/xenvif.tar";
      hash = "sha256-R8G5vG6Q4g0/UkA2oxcc9/jaHZQYb+u64NShCNt7s7U=";
    }
    {
      url = "https://web.archive.org/web/20230817071153if_/https://xenbits.xenproject.org/pvdrivers/win/xenvkbd.tar";
      hash = "sha256-CaSxCKnT/KaZw8Ma60g2z+4lOOWIRisGRtzMveQqQmM=";
    }
  ];

in
stdenv.mkDerivation {
  pname = "win-pvdrivers";
  version = "unstable-2023-08-17";

  srcs = map ({hash, url}: fetchurl {
    inherit hash url;
    # Wait & retry up to 3 times as archive.org can closes connection
    # when an HTTP client makes too many requests
    curlOpts = "--retry 3 --retry-delay 5";
  }) files;


  unpackPhase = ''
    runHook preUnpack

    for _src in $srcs; do
      mkdir -p $out
      tar xfv $_src -C $out
    done

    runHook postUnpack
  '';

  meta = with lib; {
    description = "Xen Subproject: Windows PV Drivers";
    homepage = "https://xenproject.org/developers/teams/windows-pv-drivers/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ anthonyroussel ];
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
=======
{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "win-pvdrivers";
  version = "unstable-2015-07-01";

  src = fetchFromGitHub {
    owner = "ts468";
    repo = "win-pvdrivers";
    rev = "3054d645fc3ee182bea3e97ff01869f01cc3637a";
    sha256 = "6232ca2b7c9af874abbcb9262faf2c74c819727ed2eb64599c790879df535106";
  };

  buildPhase =
    let unpack = x: "tar xf $src/${x}.tar; mkdir -p x86/${x} amd64/${x}; cp ${x}/x86/* x86/${x}/.; cp ${x}/x64/* amd64/${x}/.";
    in lib.concatStringsSep "\n" (map unpack [ "xenbus" "xeniface" "xenvif" "xennet" "xenvbd" ]);

  installPhase = ''
    mkdir -p $out
    cp -r x86 $out/.
    cp -r amd64 $out/.
  '';

  meta = with lib; {
    description = "Xen Subproject: Windows PV Driver";
    homepage = "http://xenproject.org/downloads/windows-pv-drivers.html";
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    license = licenses.bsd3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
