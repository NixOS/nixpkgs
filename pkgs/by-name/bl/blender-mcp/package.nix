# blender-mcp —— 待提交到上游 nixpkgs 的草稿
#
# 这份文件**不是**本仓的包定义。本仓生效的是 `packages/blender-mcp.nix`；
# 这份是按 nixpkgs 规范重写的、准备提交到
# `pkgs/by-name/bl/blender-mcp/package.nix` 的版本。
#
# 它留在仓库里而不是 /tmp，是为了让 dry-run 的产物可复核、可被自检盯住。
# 运行方式见同目录的 `build.sh`；提交计划见 `pr-body.md`。
#
# ── 一个曾经写错、后被实测推翻的地方（2026-10-10）───────────────────────
# 这里本来有一个 `blender ? null` 参数与配套的 postFixup，想「让插件找到 Blender」。
# 意图是：默认 null ⇒ 不拉 Blender 进闭包，想要的人自己 `.override { blender = …; }`。
#
# **实测推翻了那个意图。** 用 `callPackage { }`（不带任何参数）调用时：
#   · `blender` **仍然被自动绑定**（它存在于 nixpkgs，callPackage 就填），
#     于是 postFixup 真的执行、**整个 Blender 闭包进了每个消费者的路径**；
#   · 只有显式传 `blender = null` 才不绑（两种调用的 drvPath 不同，实测确认）。
# 也就是说 `? null` 这个默认**挡不住自动绑定**，它只掩盖了发生的事情。
#
# 所以现在把那个参数与 postFixup **整个删掉**：
# 上游本来是按 PATH 找 `blender` 的，不需要我们绑定；
# 需要固定路径的人设环境变量 `BLENDER_PATH` 即可。
# 这样这个包零 Blender 依赖——判据：drv 的引用里不再有 blender。

{
  lib,
  python3Packages,
  fetchFromGitea,
  makeWrapper,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "blender-mcp";
  version = "1.0.3";
  pyproject = true;

  # nixpkgs-vet 的两条棘轮：新顶层包必须为 true，且不得回退。
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitea {
    domain = "projects.blender.org";
    owner = "lab";
    repo = "blender_mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pYeByO4Oi5eyynsJhGVd1vBWXHvhGn+Y5LGit6Kazlw=";
  };

  # 上游把 Python 发行版放在仓库的 `mcp/` 子目录里。
  sourceRoot = "${finalAttrs.src.name}/mcp";

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [ makeWrapper ];

  dependencies = with python3Packages; [
    docutils
    mcp
    pyyaml
    # 上游声明的是 `mcp[cli]`，这两个是该 extra 带来的。
    python-dotenv
    typer
  ];

  # 测试在源树的 `tests/` 里（不在 `mcp/`），而 postPatch 跑在 sourceRoot=mcp 里，
  # 所以路径要退一级。
  #
  # 这里修的是上游测试自己的一个 bug：它构造子进程环境时**覆盖**了 PYTHONPATH
  # 而不是追加（`tests/test_mcp_server.py` 与 `tests/test_tool_listing.py` 各一处）。
  # 在 venv 里这没关系——依赖在解释器自己的 site-packages 里；
  # 在没有 venv 的构建环境里，这一行等于把依赖整个丢掉，子进程起不来，
  # 表现为一片 `McpError('Connection closed')` 与 `ModuleNotFoundError: No module named 'yaml'`。
  # 用 `--replace-fail`：上游若改了这两个文件，构建当场失败而不是静默少跑测试。
  postPatch = ''
    substituteInPlace ../tests/test_mcp_server.py \
      --replace-fail \
      'env["PYTHONPATH"] = os.path.join(_REPO_DIR, "mcp")' \
      'env["PYTHONPATH"] = os.pathsep.join([_MCP_DIR, env.get("PYTHONPATH", "")])'
    substituteInPlace ../tests/test_tool_listing.py \
      --replace-fail \
      'env["PYTHONPATH"] = os.path.join(_REPO_DIR, "mcp")' \
      'env["PYTHONPATH"] = os.pathsep.join([os.path.join(_REPO_DIR, "mcp"), env.get("PYTHONPATH", "")])'
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ];

  # 上游的测试会真的把服务端当子进程起起来并查询它，所以这些测试**必须**跑：
  # 它们验的正是这个包的核心（MCP 协议面）。关掉等于把最有价值的一层判据扔掉。
  doCheck = true;

  # 测试读的是源树里的 `tests/`，而 sourceRoot 指向 `mcp/`。
  preCheck = ''
    cd ..
    export HOME="$TMPDIR"
  '';

  # 这一个文件要**真实运行的 Blender 编辑器实例**（`FileNotFoundError: 'blender'`），
  # 在构建沙箱里永远跑不了，不是修的问题。其余三个文件全跑：
  # 实测 102 passed / 9 skipped / 0 failed。
  disabledTestPaths = [ "tests/test_blender_mcp_with_blender.py" ];

  # 把 Blender 插件一并装上，用户可以直接从包里取用。
  # 它是服务端那条 TCP 连接的另一半，缺了它整个包没有意义。
  postInstall = ''
    addonDir="$out/share/blender/scripts/addons/blender_mcp_addon"
    mkdir -p "$(dirname "$addonDir")"
    cp -r ../addon/blender_mcp_addon "$addonDir"
  '';

  pythonImportsCheck = [ "blmcp" ];

  # 自动更新：`nix-update` 支持自托管 Gitea，但它是**探测式**判断的——
  # `is_gitea_host` 先查已知 host 列表，不在列表里的就请求
  # `https://<host>/api/v1/settings/api`，返回 200 才算。
  # 实测（2026-10-10）：`projects.blender.org` 该端点返回 **200**，
  # 且 `/api/v1/repos/lab/blender_mcp/tags` 返回 `v1.0.3` 等 tag，
  # 与 `version_prefix` 从 `tag = "v${version}"` 推出的 `v` 一致。
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server exposing Blender's Python API, manual and documentation to LLM clients";
    longDescription = ''
      A lightweight Model Context Protocol server for Blender, developed by
      Blender Lab. It runs as a separate process launched by the MCP client and
      talks to a Blender add-on over a local TCP socket, letting an LLM explore
      and drive a running Blender instance.
    '';
    homepage = "https://www.blender.org/lab/mcp-server/";
    changelog = "https://projects.blender.org/lab/blender_mcp/releases/tag/v${finalAttrs.version}";
    # 依据：add-on 的 blender_manifest.toml 声明 `SPDX:GPL-3.0-or-later`，
    # 且 main 分支上有 GPL-3.0 的 LICENSE。注意 v1.0.3 那个 tag 里
    # **没有** LICENSE 文件——见 pr-body.md 的「许可依据」一节。
    license = lib.licenses.gpl3Plus;
    mainProgram = "blender-mcp";
    platforms = lib.platforms.all;
    # ⚠️ 提交时这里要填 `kihara777`，但**必须先**在
    # `maintainers/maintainer-list.nix` 里加上同名条目（那是一个独立 commit，
    # 标题 `maintainers: add kihara777`，排在包那个 commit 之前）。
    # 现在留空：条目还不存在，写上会让求值直接失败。
    maintainers = [ ];
  };
})
