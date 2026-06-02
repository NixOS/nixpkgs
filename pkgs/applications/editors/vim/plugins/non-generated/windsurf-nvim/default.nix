{
  lib,
  codeium,
  fetchFromGitHub,
  fetchurl,
  jq,
  stdenv,
  vimPlugins,
  vimUtils,
}:
let
  # Update according to https://github.com/Exafunction/codeium.nvim/blob/main/lua/codeium/versions.json
  codeiumVersion = "1.20.9";
  codeiumHashes = {
    x86_64-linux = "sha256-IeNK7UQtOhqC/eQv7MAya4jB1WIGykSR7IgutZatmHM=";
    aarch64-linux = "sha256-ujTFki/3V79El2WCkG0PJhbaMT0knC9mrS9E7Uv9HD4=";
    x86_64-darwin = "sha256-r2KloEQsUku9sk8h76kwyQuMTHcq/vwfTSK2dkiXDzE=";
    aarch64-darwin = "sha256-1jNH0Up8mAahDgvPF6g42LV+RVDVsPqDM54lE2KYY48=";
  };

  codeium' = codeium.overrideAttrs rec {
    version = codeiumVersion;

    src =
      let
        inherit (stdenv.hostPlatform) system;
        throwSystem = throw "Unsupported system: ${system}";

        platform =
          {
            x86_64-linux = "linux_x64";
            aarch64-linux = "linux_arm";
            x86_64-darwin = "macos_x64";
            aarch64-darwin = "macos_arm";
          }
          .${system} or throwSystem;

        hash = codeiumHashes.${system} or throwSystem;
      in
      fetchurl {
        name = "codeium-${version}.gz";
        url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_${platform}.gz";
        inherit hash;
      };
  };
in
vimUtils.buildVimPlugin {
  pname = "windsurf.nvim";
  version = "0-unstable-2025-04-30";
  src = fetchFromGitHub {
    owner = "Exafunction";
    repo = "windsurf.nvim";
    rev = "821b570b526dbb05b57aa4ded578b709a704a38a";
    hash = "sha256-TWezce2+XrkzaiW/V3VgfX3FMdS8qFE8/FfPEK/Ii84=";
  };

  dependencies = [ vimPlugins.plenary-nvim ];
  buildPhase = ''
    cat << EOF > lua/codeium/installation_defaults.lua
    return {
      tools = {
        language_server = "${codeium'}/bin/codeium_language_server"
      };
    };
    EOF
  '';

  doCheck = true;
  checkInputs = [
    jq
    codeium'
  ];
  checkPhase = ''
    runHook preCheck

    expected_codeium_version=$(jq -r '.version' lua/codeium/versions.json)
    actual_codeium_version=$(codeium_language_server --version)

    expected_codeium_stamp=$(jq -r '.stamp' lua/codeium/versions.json)
    actual_codeium_stamp=$(codeium_language_server --stamp | grep STABLE_BUILD_SCM_REVISION | cut -d' ' -f2)

    if [ "$actual_codeium_stamp" != "$expected_codeium_stamp" ]; then
      echo "
    The version of codeium patched in vimPlugins.codeium-nvim is incorrect.
    Expected stamp: $expected_codeium_stamp
    Actual stamp: $actual_codeium_stamp

    Expected codeium version: $expected_codeium_version
    Actual codeium version: $actual_codeium_version

    Please, update 'codeiumVersion' in pkgs/applications/editors/vim/plugins/overrides.nix accordingly to:
    https://github.com/Exafunction/codeium.nvim/blob/main/lua/codeium/versions.json
      "
      exit 1
    fi

    runHook postCheck
  '';

  meta = {
    description = "Native neovim extension for Codeium";
    homepage = "https://github.com/Exafunction/windsurf.nvim";
    license = lib.licenses.mit;
    platforms = lib.attrNames codeiumHashes;
  };
}
