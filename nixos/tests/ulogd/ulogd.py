start_all()
machine.wait_for_unit("ulogd.service")
machine.systemctl("start network-online.target")
machine.wait_for_unit("network-online.target")

with subtest("Ulogd is running"):
    machine.succeed("pgrep ulogd >&2")

# All packets show up twice in the logs
with subtest("Logs are collected"):
    machine.succeed("ping -f 127.0.0.1 -c 5 >&2")
    machine.succeed("sleep 2")
    machine.wait_until_succeeds("du /var/log/ulogd.pcap")
    _, echo_request_packets = machine.execute("tcpdump -r /var/log/ulogd.pcap icmp[0] == 8 and host 127.0.0.1")
    expected, actual = 5 * 2, len(echo_request_packets.splitlines())
    assert expected == actual, f"Expected {expected} ICMP request packets from pcap, got: {actual}"
    _, echo_reply_packets = machine.execute("tcpdump -r /var/log/ulogd.pcap icmp[0] == 0 and host 127.0.0.1")
    expected, actual = 5 * 2, len(echo_reply_packets.splitlines())
    assert expected == actual, f"Expected {expected} ICMP reply packets from pcap, got: {actual}"

    machine.wait_until_succeeds("du /var/log/ulogd_pkts.log")
    _, echo_request_packets = machine.execute("grep TYPE=8 /var/log/ulogd_pkts.log")
    expected, actual = 5 * 2, len(echo_request_packets.splitlines())
    assert expected == actual, f"Expected {expected} ICMP request packets from logfile, got: {actual}"
    _, echo_reply_packets = machine.execute("grep TYPE=0 /var/log/ulogd_pkts.log")
    expected, actual = 5 * 2, len(echo_reply_packets.splitlines())
    assert expected == actual, f"Expected {expected} ICMP reply packets from logfile, got: {actual}"

with subtest("Reloading service reopens log file"):
    machine.succeed("mv /var/log/ulogd.pcap /var/log/old_ulogd.pcap")
    machine.succeed("mv /var/log/ulogd_pkts.log /var/log/old_ulogd_pkts.log")
    machine.succeed("systemctl reload ulogd.service")
    machine.succeed("ping -f 127.0.0.1 -c 5 >&2")
    machine.succeed("sleep 2")
    machine.wait_until_succeeds("du /var/log/ulogd.pcap")
    _, echo_request_packets = machine.execute("tcpdump -r /var/log/ulogd.pcap icmp[0] == 8 and host 127.0.0.1")
    expected, actual = 5 * 2, len(echo_request_packets.splitlines())
    assert expected == actual, f"Expected {expected} packets, got: {actual}"
    _, echo_reply_packets = machine.execute("tcpdump -r /var/log/ulogd.pcap icmp[0] == 0 and host 127.0.0.1")
    expected, actual = 5 * 2, len(echo_reply_packets.splitlines())
    assert expected == actual, f"Expected {expected} packets, got: {actual}"

    machine.wait_until_succeeds("du /var/log/ulogd_pkts.log")
    _, echo_request_packets = machine.execute("grep TYPE=8 /var/log/ulogd_pkts.log")
    expected, actual = 5 * 2, len(echo_request_packets.splitlines())
    assert expected == actual, f"Expected {expected} ICMP request packets from logfile, got: {actual}"
    _, echo_reply_packets = machine.execute("grep TYPE=0 /var/log/ulogd_pkts.log")
    expected, actual = 5 * 2, len(echo_reply_packets.splitlines())
    assert expected == actual, f"Expected {expected} ICMP reply packets from logfile, got: {actual}"
