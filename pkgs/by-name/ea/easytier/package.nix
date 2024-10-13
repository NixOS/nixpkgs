{ lib, stdenv, fetchFromGitHub, rustPlatform, protobuf, nix-update-script
, darwin, withQuic ? false, # with QUIC protocol support
}:

rustPlatform.buildRustPackage rec {
  pname = "easytier";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "EasyTier";
    repo = "EasyTier";
    rev = "refs/tags/v${version}";
    hash = "sha256-0bS2VzddRZcFGmHugR0yXHjHqz06tpL4+IhQ6ReaU4Y=";
  };

  # 使用占位符 cargoSha256，稍后通过 nix build 获取正确的哈希
  cargoHash = "sha256-AkEgEymgq2asxT4oR+NtGe8bUEPRUskVvwIJYrCD7xs=";
  # protobuf 是编译时需要的原生依赖
  nativeBuildInputs = [ protobuf ];

  # 当在 macOS 上时，链接到 Apple 的安全框架
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin
    [ darwin.apple_sdk.frameworks.Security ];

  # 如果是 MIPS 平台，不使用默认特性并添加 MIPS 特性
  buildNoDefaultFeatures = stdenv.hostPlatform.isMips;
  buildFeatures = lib.optional stdenv.hostPlatform.isMips "mips"
    ++ lib.optional withQuic "quic";

  # 测试依赖过多的网络支持，暂时禁用
  doCheck = false;

  # 自动更新脚本
  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/EasyTier/EasyTier";
    changelog = "https://github.com/EasyTier/EasyTier/releases/tag/v${version}";
    description = "Simple, decentralized mesh VPN with WireGuard support";
    longDescription = ''
      EasyTier is a simple, safe and decentralized VPN networking solution implemented
      with the Rust language and Tokio framework.
    '';
    mainProgram = "easytier-core";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ ltrump ];
  };
}
