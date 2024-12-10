{
  lib,
  runCommand,
  package,
}:
runCommand "${package.pname}-tests"
  {
    HOME = "/tmp/home";
  }
  ''
    mkdir -p "''${HOME}/.aws"
    cat > "''${HOME}/.aws/config" <<'EOF'
    [profile my-profile]
    azure_tenant_id=3f03e308-ada1-45f7-9cc3-ab777eaba2d3
    azure_app_id_uri=4fbf61f5-7302-42e5-9585-b18ad0e4649d
    azure_default_username=user@example.org
    azure_default_role_arn=
    azure_default_duration_hours=1
    azure_default_remember_me=false
    EOF

    ! ${lib.getExe package} --profile=my-profile 2> stderr
    [[ "$(cat stderr)" == 'Unable to recognize page state! A screenshot has been dumped to aws-azure-login-unrecognized-state.png. If this problem persists, try running with --mode=gui or --mode=debug' ]]

    touch $out
  ''
