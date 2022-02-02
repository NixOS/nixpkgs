#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>

#define SERVER_PORT 4321
#define CLIENT_PORT 5432

#define PAYLOAD0 "bananas"
#define PAYLOAD1 "pineapples"


// like system(), but non-blocking
static pid_t system_nonblock(const char* command) {
    pid_t pid = fork();
    if (pid)
        // parent process
        return pid;

    // child process
    assert(execl("/bin/sh", "sh", "-c", command, (char *) NULL) != -1);
    return 0; // not really
}


static void test_tcp(void) {
    int listen_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    assert(listen_socket >= 0);

    //
    // test bind
    //

    struct sockaddr_in my_addr;
    memset(&my_addr, 0, sizeof my_addr);
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(SERVER_PORT);
    my_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    assert(bind(
        listen_socket,
        (struct sockaddr *)&my_addr,
        sizeof my_addr
    ) == 0);
    assert(listen(listen_socket, 2) == 0);

    //
    // test getsockname
    //

    memset(&my_addr, 0, sizeof my_addr);
    socklen_t my_addr_len = sizeof my_addr;
    assert(getsockname(
        listen_socket,
        (struct sockaddr *)&my_addr,
        &my_addr_len
    ) == 0);

    assert(my_addr_len == sizeof my_addr);
    assert(my_addr.sin_family == AF_INET);
    assert(my_addr.sin_port == htons(SERVER_PORT));
    assert(my_addr.sin_addr.s_addr == htonl(INADDR_LOOPBACK));

    pid_t child_pid = system_nonblock("./test-sockets tcp-client");

    //
    // test accept
    //

    struct sockaddr_in incoming_addr;
    memset(&incoming_addr, 0, sizeof incoming_addr);
    socklen_t incoming_addr_len = sizeof incoming_addr;
    int conn_socket = accept(
        listen_socket,
        (struct sockaddr *)&incoming_addr,
        &incoming_addr_len
    );
    assert(conn_socket >= 0);
    assert(incoming_addr_len == sizeof incoming_addr);

    assert(incoming_addr.sin_family == AF_INET);
    assert(incoming_addr.sin_port == htons(CLIENT_PORT));
    assert(incoming_addr.sin_addr.s_addr == htonl(INADDR_LOOPBACK));

    //
    // test recvfrom
    //

    char in_buffer[16];
    memset(&in_buffer, 0xff, sizeof in_buffer);
    memset(&incoming_addr, 0, sizeof incoming_addr);
    incoming_addr_len = sizeof incoming_addr;
    assert(recvfrom(
        conn_socket,
        &in_buffer,
        sizeof in_buffer,
        0,
        (struct sockaddr *)&incoming_addr,
        &incoming_addr_len
    ) == sizeof PAYLOAD0);
    assert(strncmp(PAYLOAD0, in_buffer, sizeof in_buffer) == 0);
    assert(incoming_addr_len == 0);

    int wstatus;
    assert(waitpid(child_pid, &wstatus, 0) != -1);
    assert(WIFEXITED(wstatus));
    assert(WEXITSTATUS(wstatus) == 0);
}


static void test_tcp_client(void) {
    int _socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    assert(_socket >= 0);

    //
    // test bind
    //

    struct sockaddr_in my_addr;
    memset(&my_addr, 0, sizeof my_addr);
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(CLIENT_PORT);
    my_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    assert(bind(_socket, (struct sockaddr *)&my_addr, sizeof my_addr) == 0);

    //
    // test connect
    //

    struct sockaddr_in dest_addr;
    memset(&dest_addr, 0, sizeof dest_addr);
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port = htons(SERVER_PORT);
    dest_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    assert(connect(_socket, (struct sockaddr *)&dest_addr, sizeof dest_addr) == 0);

    //
    // test sendto
    //

    assert(sendto(
        _socket,
        PAYLOAD0,
        sizeof PAYLOAD0,
        0,
        NULL,
        0
    ) == sizeof PAYLOAD0);

    //
    // test getsockname
    //

    memset(&my_addr, 0, sizeof my_addr);
    socklen_t my_addr_len = sizeof my_addr;
    assert(getsockname(
        _socket,
        (struct sockaddr *)&my_addr,
        &my_addr_len
    ) == 0);

    assert(my_addr_len == sizeof my_addr);
    assert(my_addr.sin_family == AF_INET);
    assert(my_addr.sin_port == htons(CLIENT_PORT));
    assert(my_addr.sin_addr.s_addr == htonl(INADDR_LOOPBACK));

    exit(0);
}


static void test_udp(void) {
    int _socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    assert(_socket >= 0);

    //
    // test bind
    //

    struct sockaddr_in my_addr;
    memset(&my_addr, 0, sizeof my_addr);
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(SERVER_PORT);
    my_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    assert(bind(
        _socket,
        (struct sockaddr *)&my_addr,
        sizeof my_addr
    ) == 0);

    //
    // test getsockname
    //

    memset(&my_addr, 0, sizeof my_addr);
    socklen_t my_addr_len = sizeof my_addr;
    assert(getsockname(
        _socket,
        (struct sockaddr *)&my_addr,
        &my_addr_len
    ) == 0);

    assert(my_addr_len == sizeof my_addr);
    assert(my_addr.sin_family == AF_INET);
    assert(my_addr.sin_port == htons(SERVER_PORT));
    assert(my_addr.sin_addr.s_addr == htonl(INADDR_LOOPBACK));

    pid_t child_pid = system_nonblock("./test-sockets udp-client");

    //
    // test recvfrom
    //

    struct sockaddr_in incoming_addr;
    memset(&incoming_addr, 0, sizeof incoming_addr);
    socklen_t incoming_addr_len = sizeof incoming_addr;
    char in_buffer[16];
    memset(&in_buffer, 0xff, sizeof in_buffer);
    assert(recvfrom(
        _socket,
        &in_buffer,
        sizeof in_buffer,
        0,
        (struct sockaddr *)&incoming_addr,
        &incoming_addr_len
    ) == sizeof PAYLOAD0);
    assert(strncmp(PAYLOAD0, in_buffer, sizeof in_buffer) == 0);
    assert(incoming_addr_len == sizeof incoming_addr);

    assert(incoming_addr.sin_family == AF_INET);
    assert(incoming_addr.sin_port == htons(CLIENT_PORT));
    assert(incoming_addr.sin_addr.s_addr == htonl(INADDR_LOOPBACK));

    //
    // test recvmsg
    //

    memset(&incoming_addr, 0, sizeof incoming_addr);
    memset(&in_buffer, 0xff, sizeof in_buffer);
    struct iovec _iov;
    memset(&_iov, 0, sizeof _iov);
    _iov.iov_base = &in_buffer;
    _iov.iov_len = sizeof in_buffer;
    struct msghdr _msg;
    memset(&_msg, 0, sizeof _msg);
    _msg.msg_name = &incoming_addr;
    _msg.msg_namelen = sizeof incoming_addr;
    _msg.msg_iov = &_iov;
    _msg.msg_iovlen = 1;

    assert(recvmsg(
        _socket,
        &_msg,
        0
    ) == sizeof PAYLOAD1);
    assert(strncmp(PAYLOAD1, in_buffer, sizeof in_buffer) == 0);
    assert(_msg.msg_namelen == sizeof incoming_addr);

    assert(incoming_addr.sin_family == AF_INET);
    assert(incoming_addr.sin_port == htons(CLIENT_PORT));
    assert(incoming_addr.sin_addr.s_addr == htonl(INADDR_LOOPBACK));

    int wstatus;
    assert(waitpid(child_pid, &wstatus, 0) != -1);
    assert(WIFEXITED(wstatus));
    assert(WEXITSTATUS(wstatus) == 0);
}


static void test_udp_client(void) {
    int _socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    assert(_socket >= 0);

    //
    // test bind
    //

    struct sockaddr_in my_addr;
    memset(&my_addr, 0, sizeof my_addr);
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(CLIENT_PORT);
    my_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    assert(bind(_socket, (struct sockaddr *)&my_addr, sizeof my_addr) == 0);

    //
    // test sendto
    //

    struct sockaddr_in dest_addr;
    memset(&dest_addr, 0, sizeof dest_addr);
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port = htons(SERVER_PORT);
    dest_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    assert(sendto(
        _socket,
        PAYLOAD0,
        sizeof PAYLOAD0,
        0,
        (struct sockaddr *)&dest_addr,
        sizeof dest_addr
    ) == sizeof PAYLOAD0);

    //
    // test getsockname
    //

    memset(&my_addr, 0, sizeof my_addr);
    socklen_t my_addr_len = sizeof my_addr;
    assert(getsockname(
        _socket,
        (struct sockaddr *)&my_addr,
        &my_addr_len
    ) == 0);

    assert(my_addr_len == sizeof my_addr);
    assert(my_addr.sin_family == AF_INET);
    assert(my_addr.sin_port == htons(CLIENT_PORT));
    assert(my_addr.sin_addr.s_addr == htonl(INADDR_LOOPBACK));

    //
    // test sendmsg
    //

    struct iovec _iov;
    memset(&_iov, 0, sizeof _iov);
    _iov.iov_base = PAYLOAD1;
    _iov.iov_len = sizeof PAYLOAD1;
    struct msghdr _msg;
    memset(&_msg, 0, sizeof _msg);
    _msg.msg_name = &dest_addr;
    _msg.msg_namelen = sizeof dest_addr;
    _msg.msg_iov = &_iov;
    _msg.msg_iovlen = 1;

    assert(sendmsg(
        _socket,
        &_msg,
        0
    ) == sizeof PAYLOAD1);

    exit(0);
}


static void occupy_ports(void) {
    const int socket_types[] = {SOCK_STREAM, SOCK_STREAM, SOCK_DGRAM, SOCK_DGRAM};
    const int socket_protocols[] = {IPPROTO_TCP, IPPROTO_TCP, IPPROTO_UDP, IPPROTO_UDP};
    const int ports[] = {SERVER_PORT, CLIENT_PORT, SERVER_PORT, CLIENT_PORT};
    int sockets[4];

    struct sockaddr_in my_addr;
    memset(&my_addr, 0, sizeof my_addr);
    my_addr.sin_family = AF_INET;
    my_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    for (int i=0; i<4; i++) {
        sockets[i] = socket(AF_INET, socket_types[i], socket_protocols[i]);
        assert(sockets[i] >= 0);

        my_addr.sin_port = htons(ports[i]);
        assert(bind(
            sockets[i],
            (struct sockaddr *)&my_addr,
            sizeof my_addr
        ) == 0);
        if (socket_types[i] == SOCK_STREAM)
            assert(listen(sockets[i], 2) == 0);
    }

    sleep(9999999);
}


int main(int argc, char *argv[]) {
    if (argc > 1) {
        if (!strcmp(argv[1], "tcp-client")) {
            test_tcp_client();
        }
        if (!strcmp(argv[1], "udp-client")) {
            test_udp_client();
        }
        if (!strcmp(argv[1], "occupy-ports")) {
            occupy_ports();
        }
        // execution shouldn't have reached here
        return 7;
    }

    test_tcp();
    test_udp();

    return 0;
}
