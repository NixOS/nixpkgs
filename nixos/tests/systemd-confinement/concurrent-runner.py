import click
import socket
import sys

from hypothesis import given, settings, strategies as st
from subprocess import run
from time import sleep


@st.composite
def client_actions(draw, size: int = 10):
    """
    Generate a string describing a set of actions to perform.

    This is specifically "stringly-typed" so that when looking at the output of
    a failed test run, it's easy to visually identify what's wrong.

    The string may consist of the following characters:

      ' ' - Sleep for one tick (0.1s)
      '[' - Start the client
      ']' - Stop the client
      'R' - Run a subprocess in the client

    So for example the string "  [  R ]  " would mean:

       * Sleep for two ticks ("  ")
       * Start the client ("[")
       * Sleep for two ticks ("  ")
       * Run the subprocess ("R")
       * Sleep for one tick (" ")
       * Stop the client ("]")
       * Sleep for two ticks ("  ")

    Exactly the same encoding as above is used for the network protocol, so for
    debugging issues, all you need to know is the representation above.
    """
    assert size > 1
    start = None
    stop = None
    runs = set()

    if draw(st.booleans()):
        start = draw(st.integers(min_value=0, max_value=size - 2))
        stop = draw(st.integers(min_value=start + 1, max_value=size - 1))
        if start + 1 < stop:
            runs = draw(st.sets(
                st.integers(min_value=start + 1, max_value=stop - 1),
                max_size=stop - start,
            ))

    out = ''
    for index in range(size):
        if start is not None and index == start:
            out += '['
        elif stop is not None and index == stop:
            out += ']'
        elif index in runs:
            out += 'R'
        else:
            out += ' '
    return out


@click.group()
def cli() -> None:
    pass


@cli.command('driver')
@settings(deadline=None, max_examples=20)
@given(st.lists(client_actions(), max_size=5))
def test_driver(client_actions: list[str]) -> None:
    clients: list[None | socket.socket] = [None] * len(client_actions)
    for index in range(max(map(len, client_actions), default=0)):
        for n, actions in enumerate(client_actions):
            client = clients[n]
            try:
                action = actions[index]
            except IndexError:
                continue
            match action:
                case '[':
                    client = socket.socket(socket.AF_INET6)
                    client.settimeout(60)
                    client.connect(('::1', 12345))
                    client.send(b'[')
                    clients[n] = client
                case ']':
                    assert client is not None
                    client.send(b']')
                    # At this point if we get ']' back from the client, we know
                    # that everything went smoothly up to this point because
                    # otherwise the client would have just thrown an exception
                    # and the connection would be closed.
                    assert client.recv(1) == b']'
                    assert not client.recv(1)
                    client.close()
                    clients[n] = None
                case 'R':
                    assert client is not None
                    client.send(b'R')
                case ' ':
                    if client is not None:
                        client.send(b' ')
        sleep(0.1)
    assert all(c is None for c in clients), \
           f'clients still running: {clients!r}'


@cli.command('client')
@click.argument('executable')
def test_client(executable: str) -> None:
    if not (action := sys.stdin.read(1)):
        raise SystemExit(1)
    assert action == '[', f'{action!r} != "["'
    while action := sys.stdin.read(1):
        match action:
            case 'R':
                run([executable], check=True, stdout=sys.stderr)
            case ']':
                sys.stdout.write(']')
                return
            case ' ':
                sleep(0.1)
            case '':
                raise SystemExit(1)


if __name__ == '__main__':
    cli()
