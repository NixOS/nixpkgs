#!/usr/bin/env python

import gi, argparse, os, logging, sys

gi.require_version("AccountsService", "1.0")
from gi.repository import AccountsService, GLib
from ordered_set import OrderedSet


def get_session_file(session):
    system_data_dirs = GLib.get_system_data_dirs()

    session_dirs = OrderedSet(
        os.path.join(data_dir, session)
        for data_dir in system_data_dirs
        for session in {"wayland-sessions", "xsessions"}
    )

    session_files = OrderedSet(
        os.path.join(dir, session + ".desktop")
        for dir in session_dirs
        if os.path.exists(os.path.join(dir, session + ".desktop"))
    )

    # Deal with duplicate wayland-sessions and xsessions.
    # Needed for the situation in gnome-session, where there's
    # a xsession named the same as a wayland session.
    if any(map(is_session_wayland, session_files)):
        session_files = OrderedSet(
            session for session in session_files if is_session_wayland(session)
        )
    else:
        session_files = OrderedSet(
            session for session in session_files if is_session_xsession(session)
        )

    if len(session_files) == 0:
        logging.warning("No session files are found.")
        sys.exit(0)
    else:
        return session_files[0]


def is_session_xsession(session_file):
    return "/xsessions/" in session_file


def is_session_wayland(session_file):
    return "/wayland-sessions/" in session_file


def main():
    parser = argparse.ArgumentParser(
        description="Set session type for all normal users."
    )
    parser.add_argument("session", help="Name of session to set.")

    args = parser.parse_args()

    session = getattr(args, "session")
    session_file = get_session_file(session)

    user_manager = AccountsService.UserManager.get_default()
    users = user_manager.list_users()

    for user in users:
        if user.is_system_account():
            continue
        else:
            if is_session_wayland(session_file):
                logging.debug(
                    f"Setting session name: {session}, as we found the existing wayland-session: {session_file}"
                )
                user.set_session(session)
                user.set_session_type("wayland")
            elif is_session_xsession(session_file):
                logging.debug(
                    f"Setting session name: {session}, as we found the existing xsession: {session_file}"
                )
                user.set_x_session(session)
                user.set_session(session)
                user.set_session_type("x11")
            else:
                logging.error(f"Couldn't figure out session type for {session_file}")
                sys.exit(1)


if __name__ == "__main__":
    main()
