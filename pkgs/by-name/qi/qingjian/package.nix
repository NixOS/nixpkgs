# 青简输入法（Linux）：官方源码（server + fcitx5 插件）+ 官方离线数据包。
#
# 官方主线自 2026-09-29（c08ae57）起含完整 Linux 端：
#   - apps/linux/server    Rust server（workspace 成员，Cargo.lock 已含依赖）
#   - apps/linux/fcitx5    fcitx5 插件（CMake，Fcitx5Core + nlohmann_json）
# 数据包（data-v3：词库 + hanzhang 整句模型 + assets）为官方 GitHub Release 资产，
# 版本与 sha256 由官方 tools/release/data.lock 维护；装进包后 server 的
# resource_root() 会沿 $out/share/qingjian/resources 自动找到（无需环境变量）。
{
  lib,
  stdenv,
  rustPlatform,
  cmake,
  pkg-config,
  fcitx5,
  nlohmann_json,
  openssl,
  fetchFromGitHub,
  fetchurl,
}:

let
  # 官方 main（Linux server + fcitx5 插件已在主线）
  src = fetchFromGitHub {
    owner = "qingjian-team";
    repo = "qingjian";
    rev = "c08ae57cb88b6a4a46f4a5e9c1d6d11c5e69222e";
    hash = "sha256-OulZ8oizG1XzDGX4FCZxlS5Qe3ss73isoyXPgGQIeKY=";
  };

  # Rust server（官方源码；workspace 含 macOS 专用 crate 在 Linux 上不能编译，
  # 用 -p 限定只构建/测试 qingjian-linux-server）
  server = rustPlatform.buildRustPackage {
    pname = "qingjian-server";
    version = "0.1.5-dev";
    inherit src;

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "cosmic-text-0.19.0" = "sha256-c7DuyTTF5vkClCeGGIWBX4HAMecA+1RujvVA0fcTQRE=";
      };
    };

    # buildRustPackage 的 cargo 钩子从环境变量读 flags（不自动传递同名参数）
    env = {
      cargoBuildFlags = "-p qingjian-linux-server";
      cargoTestFlags = "-p qingjian-linux-server";
    };

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];

    # 只装 server 二进制（保持 qingjian-server 名）；cargo 带 --target 构建
    installPhase = ''
      mkdir -p "$out/bin"
      cp target/x86_64-unknown-linux-gnu/release/qingjian-linux-server "$out/bin/qingjian-server"
    '';
  };

  # fcitx5 插件（官方源码 apps/linux/fcitx5；测试 target 需 Rust server，关掉）
  plugin = stdenv.mkDerivation {
    pname = "qingjian-fcitx5";
    version = "0.1.0";
    inherit src;
    sourceRoot = "source/apps/linux/fcitx5";

    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    buildInputs = [
      fcitx5
      nlohmann_json
    ];

    cmakeFlags = [ "-DBUILD_TESTING=OFF" ];
  };

  # 官方数据包（data-v3，sha256 来自官方 data.lock）
  data = fetchurl {
    url = "https://github.com/qingjian-team/qingjian/releases/download/data-v3/qingjian-data.tar.gz";
    sha256 = "42ad08fb2fe9f497c0ab191c120f05386f6adcc9d713c3283200aaed690e62f3";
  };
in
# 聚合包：server + 插件 + 数据装进同一个 $out
stdenv.mkDerivation {
  strictDeps = true;
  __structuredAttrs = true;
  pname = "qingjian";
  version = "0.1.5-unstable-2026-09-29";

  buildCommand = ''
    mkdir -p $out
    cp -r ${server}/. $out/
    cp -r ${plugin}/. $out/
    # cp -r 保留 store 只读权限，放开后后续 mkdir/解包
    chmod -R u+w $out
    mkdir -p $out/share/qingjian/resources
    tar -xzf ${data} -C $out/share/qingjian/resources
    find $out -name '._*' -delete
  '';

  meta = {
    description = "青简输入法（Linux）：本地大模型输入法，server + fcitx5 插件 + 离线词库/整句模型";
    longDescription = ''
      青简是一款带本地语言模型的中文输入法。Linux 端由官方源码提供：
      Rust server（组句/选词/整句重排）通过 Unix socket 服务 fcitx5 插件；
      词库与整句模型（hanzhang-*）随官方数据包（data-v3）分发，装进
      share/qingjian/resources，server 启动时自动定位。
    '';
    homepage = "https://github.com/qingjian-team/qingjian";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.aozora-wings ];
    platforms = lib.platforms.linux;
    mainProgram = "qingjian-server";
  };
}
