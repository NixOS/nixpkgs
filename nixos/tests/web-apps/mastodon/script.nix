{
  pkgs,
  extraInit ? "",
  extraShutdown ? "",
}:

''
  start_all()

  ${extraInit}

  server.wait_for_unit("mastodon-sidekiq-all.service")
  server.wait_for_unit("mastodon-streaming.target")
  server.wait_for_unit("mastodon-web.service")
  server.wait_for_open_port(55001)

  # Check that mastodon-media-auto-remove is scheduled
  server.succeed("systemctl status mastodon-media-auto-remove.timer")

  # Check Mastodon version from remote client
  client.succeed("curl --fail https://mastodon.local/api/v1/instance | jq -r '.version' | grep '${pkgs.mastodon.version}'")

  # Check access from remote client
  client.succeed("curl --fail https://mastodon.local/about | grep 'Mastodon hosted on mastodon.local'")
  client.succeed("curl --fail $(curl https://mastodon.local/api/v1/instance 2> /dev/null | jq -r .thumbnail) --output /dev/null")

  # Simple check tootctl commands
  # Check Mastodon version
  server.succeed("mastodon-tootctl version | grep '${pkgs.mastodon.version}'")

  # Manage accounts
  server.succeed("mastodon-tootctl email_domain_blocks add example.com")
  server.succeed("mastodon-tootctl email_domain_blocks list | grep example.com")
  server.fail("mastodon-tootctl email_domain_blocks list | grep mastodon.local")
  server.fail("mastodon-tootctl accounts create alice --email=alice@example.com")
  server.succeed("mastodon-tootctl email_domain_blocks remove example.com")
  server.succeed("mastodon-tootctl accounts create bob --email=bob@example.com")
  server.succeed("mastodon-tootctl accounts approve bob")
  server.succeed("mastodon-tootctl accounts delete bob")

  # Manage IP access
  server.succeed("mastodon-tootctl ip_blocks add 192.168.0.0/16 --severity=no_access")
  server.succeed("mastodon-tootctl ip_blocks export | grep 192.168.0.0/16")
  server.fail("mastodon-tootctl ip_blocks export | grep 172.16.0.0/16")
  client.fail("curl --fail https://mastodon.local/about")
  server.succeed("mastodon-tootctl ip_blocks remove 192.168.0.0/16")
  client.succeed("curl --fail https://mastodon.local/about")

  server.shutdown()
  client.shutdown()

  ${extraShutdown}
''
