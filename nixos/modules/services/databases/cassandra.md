# Apache Cassandra {#module-services-cassandra}

*Source:* {file}`modules/services/databases/cassandra.nix`

*Upstream documentation:* <https://cassandra.apache.org/doc/latest/>

Apache Cassandra is a distributed, wide-column NoSQL database.

To enable Cassandra, add the following to your {file}`configuration.nix`:
```nix
{ services.cassandra.enable = true; }
```

Cassandra keeps its data, commit log, saved caches and hints in subdirectories of [](#opt-services.cassandra.homeDir), {file}`/var/lib/cassandra` by default.

## Diagnostics {#module-services-cassandra-diagnostics}

Diagnostic files go to these places:

- JVM crash logs go to {file}`/tmp/hs_err_pid<pid>.log`.

- To get heap dumps, give the JVM a directory that the `cassandra` user can write, on a file system with space for an {file}`.hprof` file as large as the heap:
  ```nix
  { services.cassandra.jvmOpts = [ "-XX:HeapDumpPath=/var/lib/cassandra" ]; }
  ```

`jcmd` is the JDK's tool to send diagnostic commands to a running JVM, for example for a thread dump, a heap dump or a Java Flight Recorder recording.
It comes with the JDK that runs Cassandra, `services.cassandra.package.jre`.
Run it as the `cassandra` user:
```shell
pid=$(systemctl show --property MainPID --value cassandra.service)
runuser -u cassandra -- jcmd "$pid" VM.version
```

`jps` does not show Cassandra, because the {file}`conf/jvm-server.options` that comes with Cassandra sets `-XX:+PerfDisableSharedMem` to avoid GC pauses.
