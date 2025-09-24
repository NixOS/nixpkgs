start_all()

local.succeed("loginctl enable-linger @user_name@")

with subtest("Wait all VMs to be ready"):
    local.wait_for_unit("default.target")

with subtest("Package is installed"):
    local.succeed("su - @user_name@ --command 'command -v zellij'")

with subtest("Server works localy"):
    local.wait_for_unit("zellij-web.service", "@user_name@")
    local.succeed("curl --silent --show-error http://localhost:@port@/")
