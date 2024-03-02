# Control Groups {#sec-cgroups}

To keep track of the processes in a running system, systemd uses
*control groups* (cgroups). A control group is a set of processes used
to allocate resources such as CPU, memory or I/O bandwidth. There can be
multiple control group hierarchies, allowing each kind of resource to be
managed independently.

The command `systemd-cgls` lists all control groups in the `systemd`
hierarchy, which is what systemd uses to keep track of the processes
belonging to each service or user session:

```ShellSession
$ systemd-cgls
├─user
│ └─eelco
│   └─c1
│     ├─ 2567 -:0
│     ├─ 2682 kdeinit4: kdeinit4 Running...
│     ├─ ...
│     └─10851 sh -c less -R
└─system
  ├─httpd.service
  │ ├─2444 httpd -f /nix/store/3pyacby5cpr55a03qwbnndizpciwq161-httpd.conf -DNO_DETACH
  │ └─...
  ├─dhcpcd.service
  │ └─2376 dhcpcd --config /nix/store/f8dif8dsi2yaa70n03xir8r653776ka6-dhcpcd.conf
  └─ ...
```

Similarly, `systemd-cgls cpu` shows the cgroups in the CPU hierarchy,
which allows per-cgroup CPU scheduling priorities. By default, every
systemd service gets its own CPU cgroup, while all user sessions are in
the top-level CPU cgroup. This ensures, for instance, that a thousand
run-away processes in the `httpd.service` cgroup cannot starve the CPU
for one process in the `postgresql.service` cgroup. (By contrast, it
they were in the same cgroup, then the PostgreSQL process would get
1/1001 of the cgroup's CPU time.) You can limit a service's CPU share in
`configuration.nix`:

```nix
systemd.services.httpd.serviceConfig.CPUShares = 512;
```

By default, every cgroup has 1024 CPU shares, so this will halve the CPU
allocation of the `httpd.service` cgroup.

There also is a `memory` hierarchy that controls memory allocation
limits; by default, all processes are in the top-level cgroup, so any
service or session can exhaust all available memory. Per-cgroup memory
limits can be specified in `configuration.nix`; for instance, to limit
`httpd.service` to 512 MiB of RAM (excluding swap):

```nix
systemd.services.httpd.serviceConfig.MemoryLimit = "512M";
```

The command `systemd-cgtop` shows a continuously updated list of all
cgroups with their CPU and memory usage.
