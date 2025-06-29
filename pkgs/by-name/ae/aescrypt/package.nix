{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libiconv,
}:

let
  terrapaneRepos = [
    {
      name = "aescrypt_engine";
      tag = "v4.1.0";
      hash = "sha256-Vcsumh3/vJftMqZGBThJUNgRrxnaRWID3tntN9qf/bg=";
    }
    {
      name = "program_options";
      tag = "v1.0.2";
      hash = "sha256-vymbD64K8f3wuY3W5QAKQ+gIbDxhZwnoItOkRbg7j9M=";
    }
    {
      name = "conio";
      tag = "v1.0.3";
      hash = "sha256-nXRz0pjH3gSDH2VPz7ECb8lQ/tgDHcWEFON+eqzfWCA=";
    }
    {
      name = "logger";
      tag = "v1.0.5";
      hash = "sha256-L/PJ3Gn0dyb1qNS/JTRLoaRNAA92p0J/f+8OAUh0768=";
    }
    {
      name = "secutil";
      tag = "v1.0.6";
      hash = "sha256-4mDiTDY7++GJB/2v8oli/MV6pTjoSLgfjeX/Jyi1nEI=";
    }
    {
      name = "random";
      tag = "v1.0.2";
      hash = "sha256-VJmZhYFA4UBzDjQIcuHWN6MwDBXZULuTbQA4xzA8wnk=";
    }
    {
      name = "charutil";
      tag = "v1.0.3";
      hash = "sha256-yXZhVLJqX0anFDjLwxGbdyZ8Z8kkcWHjHy2p6NBX6LM=";
    }
    {
      name = "libaes";
      tag = "v1.1.0";
      hash = "sha256-a3A3WNsnvjQhlR0eNj0AEp7MrNMiNFVgotEkQnc3usM=";
    }
    {
      name = "libhash";
      tag = "v1.0.7";
      hash = "sha256-O3rzbBPPEQEzI5+OtIk7zesfyzvpjPJiioF5DMFbZHg=";
    }
    {
      name = "libkdf";
      tag = "v1.0.7";
      hash = "sha256-7FkPs9kUQ80lj3WkK3z56cwOT597dUBou0VDZfYteVo=";
    }
    {
      name = "bitutil";
      tag = "v1.0.2";
      hash = "sha256-V3/G8lTw1tYAYsjgehjbGXeOfnpdPtzFY5XdLEHtAl4=";
    }
  ];

  fetchedRepos =
    lib.mapAttrs
      (
        _: r:
        fetchFromGitHub {
          owner = "terrapane";
          repo = r.name;
          tag = r.tag;
          hash = r.hash;
        }
      )
      (
        lib.listToAttrs (
          map (r: {
            name = r.name;
            value = r;
          }) terrapaneRepos
        )
      );
in
stdenv.mkDerivation (finalAttrs: {
  version = "4.3.0";
  pname = "aescrypt";

  src = fetchFromGitHub {
    owner = "terrapane";
    repo = "aescrypt_cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oB6H1FdTVy+qandtskouBclin2sgLALoZ2QPCVb5Iy4=";
  };

  postPatch = ''
    ${lib.concatMapStringsSep "\n" (r: ''
      cp --recursive --no-preserve=mode ${fetchedRepos.${r}} dependencies/${r}
    '') (lib.attrNames fetchedRepos)}
  '';

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-liconv";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libiconv ];

  cmakeFlags = lib.flatten [
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-Daescrypt_cli_BUILD_TESTS=ON"
    "-Daescrypt_ENABLE_LICENSE_MODULE=OFF"
    (lib.concatMapStringsSep "\n" (
      repo: "-DFETCHCONTENT_SOURCE_DIR_${lib.toUpper repo.name}=../dependencies/${repo.name}"
    ) terrapaneRepos)
  ];

  meta = {
    description = "Encrypt files with Advanced Encryption Standard (AES)";
    homepage = "https://www.aescrypt.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      lovek323
      qknight
    ];
    platforms = lib.platforms.unix;
  };
})
