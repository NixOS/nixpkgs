# Falco {#module-services-falco}

[Falco](https://falco.org) is a runtime security tool. It watches the system
calls made on the host and in its containers through an eBPF probe, evaluates
them against a set of rules, and emits an alert when one matches: a shell
opened in a container, a sensitive file read by an unexpected program, a binary
written below `/etc`.

This module runs Falco with the modern eBPF probe, which is built into the
package and needs no kernel module. It requires a kernel of at least 5.8 with
BTF, which every NixOS kernel provides. The kernel module and the legacy eBPF
probe are not supported.

## Basic usage {#module-services-falco-basic-usage}

```nix
{ services.falco.enable = true; }
```

This starts `falco.service` with the stock rules from
[falcosecurity/rules](https://github.com/falcosecurity/rules), which are
pinned by the package, and with the `container` plugin, which adds the
container and image to every event. Alerts are written to the journal:

```ShellSession
$ journalctl -u falco -f
```

The `falco` command is installed as well, to list what is being checked:

```ShellSession
$ falco -c /etc/falco/falco.yaml --list
```

## Configuration {#module-services-falco-configuration}

[](#opt-services.falco.settings) is the content of `falco.yaml`, written as Nix.
Every key of the [reference](https://falco.org/docs/reference/daemon/config-options/)
is available. The module sets the keys it needs to load the stock rules and the
container plugin; lists you add to those are appended to them.

```nix
{
  services.falco = {
    enable = true;
    settings = {
      # Drop everything below this priority.
      priority = "warning";
      json_output = true;
    };
  };
}
```

## Writing rules {#module-services-falco-rules}

[](#opt-services.falco.rules) holds rule files, each the YAML list that Falco
reads, written as Nix. The attribute name is the file name. Rules, macros and
lists can be mixed in a file:

```nix
{
  services.falco.rules."50-local" = [
    {
      list = "admin_tools";
      items = [
        "kubectl"
        "helm"
      ];
    }
    {
      macro = "admin_tool";
      condition = "proc.name in (admin_tools)";
    }
    {
      rule = "Admin tool in container";
      desc = "An admin tool ran inside a container";
      condition = "spawned_process and container and admin_tool";
      output = "Admin tool in container (proc=%proc.cmdline image=%container.image.repository)";
      priority = "NOTICE";
      tags = [
        "container"
        "local"
      ];
    }
  ];
}
```

Files are loaded after the stock rules, in the lexical order of their names, so
they can use the stock macros and lists and can override them. Prefer an
override to a copy of the stock rule, which would stop receiving fixes:

```nix
{
  services.falco.rules."60-tuning" = [
    # A known program that is allowed to read sensitive files.
    {
      macro = "user_known_read_sensitive_files_activities";
      condition = "(proc.name = backup-agent)";
      override.condition = "replace";
    }
    # Extend a stock rule instead of redefining it.
    {
      rule = "Terminal shell in container";
      condition = "and not container.image.repository = registry.example.com/debug-tools";
      override.condition = "append";
    }
  ];
}
```

See the [rules reference](https://falco.org/docs/concepts/rules/) for the
format, and the stock rules for the macros meant to be overridden (the
`user_known_*` ones).

::: {.note}
The configuration and every rule file that is a store path are validated with
`falco --validate` while the system is built. A rule that does not compile, or
an override with nothing to override, fails `nixos-rebuild` instead of the
service. Rule files that are runtime paths in `rules_files`, such as a
directory under `/var/lib`, cannot be checked and are left to Falco.
:::

## Outputs {#module-services-falco-outputs}

Alerts go to the journal through standard output. Falco can write them to more
places at once; use JSON when something else reads them:

```nix
{
  services.falco.settings = {
    json_output = true;

    # A file, for a log shipper such as vector or promtail. The unit's
    # LogsDirectory makes /var/log/falco writable.
    file_output = {
      enabled = true;
      keep_alive = true;
      filename = "/var/log/falco/events.json";
    };

    # A webhook, such as a Falcosidekick instance.
    http_output = {
      enabled = true;
      url = "http://127.0.0.1:2801/";
    };
  };
}
```

Falco does not rotate the file it writes. After rotating it, have Falco reopen
it with `systemctl kill --signal=SIGUSR1 falco`.

## Health and metrics {#module-services-falco-webserver}

The embedded web server is disabled, and listens on the loopback address when
enabled. It serves a health endpoint, and Prometheus metrics when asked:

```nix
{
  services.falco.settings = {
    webserver = {
      enabled = true;
      prometheus_metrics_enabled = true;
    };
    metrics.enabled = true;
  };
}
```

```ShellSession
$ curl http://127.0.0.1:8765/healthz
$ curl http://127.0.0.1:8765/metrics
```

## Best practices {#module-services-falco-best-practices}

- **Let it fail at build time.** Keep rules in [](#opt-services.falco.rules) so
  that they are validated by the build. A typo in a macro name then never
  reaches the machine.

- **Override, do not copy.** Tune the stock rules with an `override`, ideally
  through their `user_known_*` macros. Rules and macros are updated with the
  package, and an override keeps working across the update; a copy does not.

- **Start from the alerts you get.** The stock rules are broad, and the first
  days are noisy. Add exceptions for the programs you know until what is left
  is worth reading, then raise `priority` to hide the rest.

- **Send alerts where someone will see them.** An alert in the journal is only
  found by looking. Forward them with `file_output` or `http_output` to the
  system that pages you.

- **Keep the web server on the loopback address.** It has no authentication.
  If Prometheus scrapes it from another host, restrict the port in the firewall
  instead of listening on `0.0.0.0`.

- **Update the rules with the package.** The stock rules are those of the
  package version, so updating `nixpkgs` updates them. Rules are not fetched
  at runtime, so what is deployed is what was built and validated.

- **Watch for dropped events.** On a host with a heavy syscall load, Falco can
  fall behind and drops events; it logs this and, with `metrics` enabled,
  counts it. Raise `engine.modern_ebpf.buf_size_preset` first. Falco is only
  as good as the events it sees.

- **Do not widen the unit.** The service runs with only the four capabilities
  the modern eBPF probe needs (`CAP_BPF`, `CAP_PERFMON`, `CAP_SYS_PTRACE` and
  `CAP_SYS_RESOURCE`), a read-only file system and no new privileges. Those
  are enough, and the probe is the sensitive part, not the process around it.
