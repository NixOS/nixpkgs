#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: with ps; [ ])" nix
"""
Converts old aliases to warnings, converts old warnings to throws, and removes old throws.
Example usage:
./maintainers/scripts/remove-old-aliases.py --year 2018 --file ./pkgs/top-level/aliases.nix

Check this file with mypy after every change!
$ mypy --strict maintainers/scripts/remove-old-aliases.py
"""
import argparse
import shutil
import subprocess
from datetime import date as datetimedate
from datetime import datetime
from pathlib import Path


def process_args() -> argparse.Namespace:
    """process args"""
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument(
        "--year", required=True, type=int, help="operate on aliases older than $year"
    )
    arg_parser.add_argument(
        "--month",
        type=int,
        default=1,
        help="operate on aliases older than $year-$month",
    )
    arg_parser.add_argument(
        "--only-throws",
        action="store_true",
        # help="only operate on throws. e.g remove throws older than $date",.
        help="Deprecated, use --only throws instead"
    )
    arg_parser.add_argument(
        "--only",
        choices=["aliases", "warnings", "throws"],
        help="Only act on the specified types"
             "(i.e. only act on entries that are 'normal' aliases, warnings, or throws)."
             "Can be repeated.",
        action="append",
        dest="operate_on"
    )
    arg_parser.add_argument("--file", required=True, type=Path, help="alias file")
    arg_parser.add_argument(
        "--dry-run", action="store_true", help="don't modify files, only print results"
    )
    parsed = arg_parser.parse_args()

    if parsed.only_throws:
        parsed.operate_on.append("throws")
    del parsed.only_throws

    if parsed.operate_on is None:
        parsed.operate_on = ["aliases", "warnings", "throws"]

    return parsed


def get_date_lists(
    txt: list[str], cutoffdate: datetimedate, operate_on: list[str]
) -> tuple[list[str], list[str], list[str], list[str]]:
    """get a list of lines in which the date is older than $cutoffdate"""
    date_sep_line_list: list[str] = []
    date_older_list: list[str] = []
    date_older_throw_list: list[str] = []
    date_older_warning_list: list[str] = []

    for lineno, line in enumerate(txt, start=1):
        line = line.rstrip()
        my_date = None
        for string in line.split():
            string = string.strip(":")
            try:
                # strip ':' incase there is a string like 2019-11-01:
                my_date = datetime.strptime(string, "%Y-%m-%d").date()
            except ValueError:
                try:
                    my_date = datetime.strptime(string, "%Y-%m").date()
                except ValueError:
                    continue

        if (
            my_date is None
            or my_date > cutoffdate
            or "preserve, reason:" in line.lower()
        ):
            continue

        if "=" not in line:
            date_sep_line_list.append(f"{lineno} {line}")
        # 'if' lines could be complicated.
        elif ("if " in line and "if =" not in line) or "MANUAL" in line:
            print(f"RESOLVE MANUALLY {line}")
        elif "lib.warnOnInstantiate" in line or "warning" in line:
            date_older_warning_list.append(line)
        elif "throw" in line:
            date_older_throw_list.append(line)
        else:
            date_older_list.append(line)

    return (
        date_sep_line_list,
        date_older_list,
        date_older_warning_list,
        date_older_throw_list,
    )

def convert_to_warning(date_older_list: list[str]) -> list[tuple[str, str]]:
    """convert a list of lines to warnings"""
    converted_list = []
    for line in date_older_list.copy():
        indent: str = " " * (len(line) - len(line.lstrip()))
        before_equal = ""
        after_equal = ""
        try:
            before_equal, after_equal = (x.strip() for x in line.split("=", maxsplit=2))
        except ValueError as err:
            print(err, line, "\n")
            date_older_list.remove(line)
            continue

        alias = before_equal
        alias_unquoted = before_equal.strip('"')
        replacement = next(x.strip(";:") for x in after_equal.split())
        replacement = replacement.removeprefix("pkgs.")

        converted = (
            f"{indent}{alias} = lib.warnOnInstantiate \"'{alias_unquoted}' has been"
            f" renamed to/replaced by '{replacement}'\" {replacement};"
            f" # Converted to warning {datetime.today().strftime('%Y-%m-%d')}"
        )
        converted_list.append((line, converted))

    return converted_list

def convert_to_throw(date_older_warning_list: list[str]) -> list[tuple[str, str]]:
    """convert a list of warnings to throws"""
    converted_list = []
    for line in date_older_warning_list.copy():
        indent: str = " " * (len(line) - len(line.lstrip()))
        before_equal = ""
        after_equal = ""
        try:
            before_equal, after_equal = (x.strip() for x in line.split("=", maxsplit=2))
        except ValueError as err:
            print(err, line, "\n")
            date_older_warning_list.remove(line)
            continue

        alias = before_equal
        alias_unquoted = before_equal.strip('"')
        replacement = next(x.strip(";:") for x in after_equal.split(";"))
        replacement = replacement.split(" ")[-1].removeprefix("pkgs.")

        converted = (
            f"{indent}{alias} = throw \"'{alias_unquoted}' has been"
            f" renamed to/replaced by '{replacement}'\";"
            f" # Converted to throw {datetime.today().strftime('%Y-%m-%d')}"
        )
        converted_list.append((line, converted))

    return converted_list


def generate_text_to_write(
    txt: list[str],
    date_older_list: list[str],
    converted_to_throw: list[tuple[str, str]],
    date_older_throw_list: list[str],
    converted_to_warning: list[tuple[str, str]],
    date_older_warning_list: list[str],
) -> list[str]:
    """generate a list of text to be written to the aliasfile"""
    text_to_write: list[str] = []
    for line in txt:
        text_to_append: str = ""
        for tupl in converted_to_throw:
            if line == tupl[0]:
                text_to_append = f"{tupl[1]}\n"
        for tupl in converted_to_warning:
            if line == tupl[0]:
                text_to_append = f"{tupl[1]}\n"
        if line not in (date_older_list + date_older_throw_list + date_older_warning_list):
            text_to_append = f"{line}\n"
        if text_to_append:
            text_to_write.append(text_to_append)

    return text_to_write


def write_file(
    aliasfile: Path,
    text_to_write: list[str],
) -> None:
    """write file"""
    temp_aliasfile = Path(f"{aliasfile}.raliases")
    with open(temp_aliasfile, "w", encoding="utf-8") as far:
        for line in text_to_write:
            far.write(line)
    print("\nChecking the syntax of the new aliasfile")
    try:
        subprocess.run(
            ["nix-instantiate", "--eval", temp_aliasfile],
            check=True,
            stdout=subprocess.DEVNULL,
        )
    except subprocess.CalledProcessError:
        print(
            "\nSyntax check failed,",
            "there may have been a line which only has\n"
            'aliasname = "reason why";\n'
            "when it should have been\n"
            'aliasname = throw "reason why";',
        )
        temp_aliasfile.unlink()
        return
    shutil.move(f"{aliasfile}.raliases", aliasfile)
    print(f"{aliasfile} modified! please verify with 'git diff'.")


def main() -> None:
    """main"""
    args = process_args()

    aliasfile = Path(args.file).absolute()
    cutoffdate = (datetime.strptime(f"{args.year}-{args.month}-01", "%Y-%m-%d")).date()

    txt: list[str] = (aliasfile.read_text(encoding="utf-8")).splitlines()

    date_older_list: list[str] = []
    date_sep_line_list: list[str] = []
    date_older_warning_list: list[str] = []
    date_older_throw_list: list[str] = []

    date_sep_line_list, date_older_list, date_older_warning_list, date_older_throw_list = get_date_lists(
        txt, cutoffdate, args.operate_on
    )


    converted_to_warning: list[tuple[str, str]] = convert_to_warning(date_older_list)
    if date_older_list and "aliases" in args.operate_on:
        print(" Will be converted to warnings. ".center(100, "-"))
        for l_n in date_older_list:
            print(l_n)

    converted_to_throw: list[tuple[str, str]] = convert_to_throw(date_older_warning_list)
    if date_older_warning_list and "warnings" in args.operate_on:
        print(" Will be converted to throws. ".center(100, "-"))
        for l_n in date_older_warning_list:
            print(l_n)

    if date_older_throw_list and "throws" in args.operate_on:
        print(" Will be removed. ".center(100, "-"))
        for l_n in date_older_throw_list:
            print(l_n)

    if date_sep_line_list:
        print(" On separate line, resolve manually. ".center(100, "-"))
        for l_n in date_sep_line_list:
            print(l_n)


    if not args.dry_run:
        text_to_write = generate_text_to_write(
            txt,
            date_older_list if "aliases" in args.operate_on else [],
            converted_to_throw if "warnings" in args.operate_on else [],
            date_older_throw_list if "throws" in args.operate_on else [],
            converted_to_warning if "aliases" in args.operate_on else [],
            date_older_warning_list if "warnings" in args.operate_on else [],
        )
        write_file(aliasfile, text_to_write)


if __name__ == "__main__":
    main()
