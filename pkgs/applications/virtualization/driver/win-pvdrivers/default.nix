{ lib, stdenvNoCC, fetchurl }:

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
stdenvNoCC.mkDerivation {
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
  };
}
