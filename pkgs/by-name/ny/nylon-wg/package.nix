{
  lib,
  buildGoModule,
  darwin,
  fetchFromGitHub,
  installShellFiles,
  iproute2,
  stdenv,
}:
buildGoModule rec {
  pname = "nylon-wg";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "encodeous";
    repo = "nylon";
    tag = "v${version}";
    hash = "sha256-l2tSBTdfCmfG8zf/J6b9i7oJyj4FPhABwEj6PNbwsik=";
  };

  vendorHash = "sha256-az1Qf01x7Mx7lFdp1zNNCELXQf+7/uWMTKGxSK+TRGE=";

  nativeBuildInputs = [ installShellFiles ];

  postPatch =
    # Replace `Exec("ip"` on linux with absolute path
    lib.optionalString stdenv.isLinux ''
      substituteInPlace core/sys_linux.go \
          --replace-fail "Exec(\"ip\"" "Exec(\"${iproute2}/bin/ip\""
    ''
    +
      # Replace "/sbin/ifconfig" and "/sbin/route" with absolute path
      lib.optionalString stdenv.isDarwin ''
        substituteInPlace core/sys_darwin.go \
            --replace-fail "/sbin/route" "${darwin.network_cmds}/bin/route"
        substituteInPlace core/sys_darwin.go \
            --replace-fail "/sbin/ifconfig" "${darwin.network_cmds}/bin/ifconfig"
      '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd nylon \
      --bash <($out/bin/nylon completion bash) \
      --fish <($out/bin/nylon completion fish) \
      --zsh <($out/bin/nylon completion zsh)
  '';

  meta = {
    homepage = "https://github.com/encodeous/nylon";
    description = "Resilient Overlay Network built from WireGuard";
    license = lib.licenses.mit;
    mainProgram = "nylon";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ smephite ];
  };
}
