# Patched lldb for Rust language support.
{ fetchFromGitHub, runCommand, llvmPackages }:
let
  llvmSrc = fetchFromGitHub {
    owner = "vadimcn";
    repo = "llvm-project";
    # codelldb/14.x branch
    rev = "4c267c83cbb55fedf2e0b89644dc1db320fdfde7";
    sha256 = "sha256-jM//ej6AxnRYj+8BAn4QrxHPT6HiDzK5RqHPSg3dCcw=";
  };
in (llvmPackages.lldb.overrideAttrs (oldAttrs: rec {
  passthru = (oldAttrs.passthru or {}) // {
    inherit llvmSrc;
  };

  doInstallCheck = true;

  # installCheck for lldb_14 currently broken
  # https://github.com/NixOS/nixpkgs/issues/166604#issuecomment-1086103692
  # ignore the oldAttrs installCheck
  installCheckPhase = ''
    versionOutput="$($out/bin/lldb --version)"
    echo "'lldb --version' returns: $versionOutput"
    echo "$versionOutput" | grep -q 'rust-enabled'
  '';
})).override({
  monorepoSrc = llvmSrc;
  libllvm = llvmPackages.libllvm.override({ monorepoSrc = llvmSrc; });
})
