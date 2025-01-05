# pyright: strict
from collections.abc import Sequence
from dataclasses import dataclass
import logging
import subprocess
import re
from pathlib import Path
from typing import Final

# NOTES on output of LD_DEBUG=libs
# - Seems like the output is always slightly indented (three spaces?)

LOGGER: Final[logging.Logger] = logging.getLogger(__name__)

type PID = int

# Have some function which switches depending on the type of the line

def continuation_trying_file(line: str):
    """
    Continuation function for the trying file line.
    """
    match line.split("=", maxsplit=1):
        case ("trying file", rest):
            return parse_trying_file(rest)
        case ("search cache", rest):
            return parse_search_cache(rest)
        case ("search path", rest):
            return parse_search_path(rest)
        case [""]:
            return 
        case _:
            raise ValueError(f"Failed to match line: {line}")

def parse_trying_file(line: str):
    """
    When we get a line which matches "trying file=", we parse the line and return a function
    which should be applied to the following line.
    """
    pat = re.compile(r"^trying\ file=(?P<path>[^\s]+)$")
    match = pat.match(line)
    if match is None:
        raise ValueError(f"Failed to match line: {line}")

    path = Path(match.group("path"))

    return TryingFile(path=path), continuation_trying_file

def parse_search_path(line: str):
    """
    When we get a line which matches "search path=", we parse the line and return a function
    which should be applied to the following line.
    """
    pat = re.compile(r"^search\ path=(?P<paths>[^\s]+)\s*(?P<source>\(.+\))\s*$")
    match = pat.match(line)
    if match is None:
        raise ValueError(f"Failed to match line: {line}")

    paths = list(map(Path, match.group("paths").split(":")))
    source = match.group("source")

    # Search path is always followed by a trying file

    return SearchPath(path=path)

def parse_search_cache(line: str):
    """
    When we get a line which matches "search cache=", we parse the line and return a function
    which should be applied to the following line.
    """
    pat = re.compile(r"^search\ cache=(?P<path>[^\s]+)$")
    match = pat.match(line)
    if match is None:
        raise ValueError(f"Failed to match line: {line}")

    path = Path(match.group("path"))

    # Search cache is always followed by a search path



    return SearchCache(path=path)


def parse_find_library(line: str):
    """
    When we get a line which matches "find library=", we parse the line and return a function
    which should be applied to the following line.
    """
    pat = re.compile(r"^find\ library=(?P<soname>[^\s]+)\[(?P<times_found>\d+)\];\ searching$")
    match = pat.match(line)
    if match is None:
        raise ValueError(f"Failed to match line: {line}")

    soname = match.group("soname")
    times_found = int(match.group("times_found"))



    def continuation(line: str):
        """
        Continuation function for the find library line.
        """
        match line.split("=", maxsplit=1):
            case ("search cache", rest):
                return parse_search_cache(rest)
            case ("search path", rest):
                return parse_search_path(soname, rest)
            case _:
                raise ValueError(f"Failed to match line: {line}")


# (RPATH from file /home/connorbaker/micromamba/envs/testLibs/bin/python3)
# (LD_LIBRARY_PATH)
# (system search path)


@dataclass
class TryingFile:
    path: Path


@dataclass
class SearchPathSystemPath:
    path: list[Path]
    tries: list[TryingFile]


@dataclass
class SearchPathLdLibraryPath:
    path: list[Path]
    tries: list[TryingFile]


@dataclass
class SearchPathRPath:
    path: list[Path]
    from_file: Path
    tries: list[TryingFile]


type SearchPath = SearchPathSystemPath | SearchPathLdLibraryPath | SearchPathRPath


@dataclass
class SearchCache:
    path: Path


@dataclass
class FindLibrary:
    soname: str  # The name of the library
    entries: list[SearchPath | SearchCache]


type SearchLineObject = FindLibrary | SearchPath | SearchCache


@dataclass
class CallingInit:
    path: Path


@dataclass
class InitializeProgram:
    path: Path


@dataclass
class TransferringControl:
    path: Path


@dataclass
class CallingFini:
    path: None | Path


def parse_pid(line: str) -> tuple[PID, str]:
    """
    Returns the PID and the remainder of the line.
    """
    line = line.strip()
    match line.split(":", maxsplit=1):
        case (pid, payload):
            return int(pid), payload
        case _:
            raise ValueError(f"Failed to parse line: {line}")


def parse_line_type(line: str) -> tuple[LineType, None | str]:
    line = line.strip()
    if line == "":
        return LineBreakType(), None

    # Test for search line type
    match line.split("=", maxsplit=1):
        case ("find library", rest):
            return FindLibraryType(), rest
        case ("search path", rest):
            return SearchPathType(), rest
        case ("trying file", rest):
            return TryingFileType(), rest
        case ("search cache", rest):
            return SearchCacheType(), rest
        case _:
            pass

    # Test for control line type
    match line.split(": ", maxsplit=1):
        case ("calling init", rest):
            return CallingInitType(), rest
        case ("initialize program", rest):
            return InitializeProgramType(), rest
        case ("transferring control", rest):
            return TransferringControlType(), rest
        case ("calling fini", rest):
            return CallingFiniType(), rest
        case _:
            pass

    raise ValueError(f"Failed to parse line: {line}")


type TopLevelType = FindLibraryType | CallingInitType | InitializeProgramType | TransferringControlType | CallingFiniType

def chunks_by_pid(lines: Sequence[str]) -> dict[PID, list[tuple[TopLevelType, list[str]]]]:
    pids: dict[PID, list[list[str]]] = {}
    for line in lines:
        pid, rest = parse_pid(line)
        chunks = pids.setdefault(pid, [])

        rest = rest.strip()

        # If rest is empty, then we have a line break
        if rest == "":
            chunks.append([])
            continue
        else:
            current_chunk.append(rest)

    # Remove any empty chunks
    pids = {pid: [chunk for chunk in chunks if chunk] for pid, chunks in pids.items()}

    return pids


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)

    result = subprocess.run(
        args=["/home/connorbaker/micromamba/envs/testLibs/bin/python3", "--version"],
        env={"LD_DEBUG": "libs"},
        capture_output=True,
        text=True,
    )

    for pid, chunks in chunks_by_pid(result.stderr.splitlines()).items():
        LOGGER.debug("PID: %s", pid)
        for chunk in chunks:
            LOGGER.debug("Chunk:")
            for line in chunk:
                LOGGER.debug("  %s", line)

    # context: dict[PID, dict[NonEmptyLineType, ]] = {}
    # finished: dict[PID, dict[NonEmptyLineType, list[str]]] = {}
    # for line in result.stderr.splitlines():
    #     pid, rest = parse_pid(line)
    #     pid_context = context.get(pid, {})

    #     line_type, rest = parse_line_type(rest)
    #     match line_type:
    #         case LineBreakType():
    #             # Finalize the context for the PID
    #             raise NotImplementedError("LineBreakType not implemented")

    #         # All of the following cases involve creating a new object to add to the context
    #         case FindLibraryType():

    #     LOGGER.debug("PID: %s, Line Type: %s", pid, line_type)

    # structured_lines = []

    # pid_matcher = re.compile(
    #     r"""
    #     ^ # Start of line
    #     \s+ # Leading indentation
    #     (?P<pid>\d+) # Process ID
    #     : # Colon
    #     \s* # Possible leading assuming not a newline
    #     (?P<payload> # Start of optional payload
    #         (?P<find_library> # Start case: find library
    #             find\ library=
    #             (?P<find_library_soname>[^\s]+)
    #             (?P<find_library_rest>.*) # Rest of the line
    #         )  # End case: find library

    #         | # OR

    #         (?P<search_path> # Start case: search path
    #             search\ path=
    #             (?P<search_path_path>[^\s]+)
    #             (?P<search_path_rest>.*) # Rest of the line
    #             # TODO: Add type of search path
    #         ) # End case: search path

    #         | # OR

    #         (?P<trying_file> # Start case: trying file
    #             trying\ file=
    #             (?P<trying_file_path>[^\s]+)
    #             (?P<trying_file_rest>.*) # Rest of the line
    #         ) # End case: trying file

    #         | # OR

    #         (?P<search_cache> # Start case: search cache
    #             search\ cache=
    #             (?P<search_cache_path>[^\s]+)
    #             (?P<search_cache_rest>.*) # Rest of the line
    #         ) # End case: search cache

    #         | # OR

    #         (?P<calling_init> # Start case: calling init
    #             calling\ init:\
    #             (?P<calling_init_path>[^\s]+)
    #             (?P<calling_init_rest>.*) # Rest of the line
    #         ) # End case: calling init

    #         | # OR

    #         (?P<initialize_program> # Start case: initialize program
    #             initialize\ program:\
    #             (?P<initialize_program_path>[^\s]+)
    #             (?P<initialize_program_rest>.*) # Rest of the line
    #         ) # End case: initialize program

    #         | # OR

    #         (?P<transferring_control> # Start case: transferring control
    #             transferring\ control:\
    #             (?P<transferring_control_path>[^\s]+)
    #             (?P<transferring_control_rest>.*) # Rest of the line
    #         ) # End case: transferring control

    #         | # OR

    #         (?P<calling_fini> # Start case: calling fini
    #             calling\ fini:\
    #             (?P<calling_fini_path>[^\s]+)
    #             (?P<calling_fini_rest>.*) # Rest of the line
    #         ) # End case: calling fini
    #     )? # End of optional payload
    #     $ # End of line
    #     """,
    #     re.VERBOSE,
    # )
    # for line in result.stderr.splitlines():
    #     match = pid_matcher.match(line)
    #     if match is None:
    #         LOGGER.error("Failed to match line %s", line)
    #         sys.exit(1)

    #     if not match.group("payload"):
    #         LOGGER.debug("Linebreak")
    #         continue
    #     elif match.group("find_library"):
    #         LOGGER.debug("find library: %s", match.group("find_library_soname"))
    #     elif match.group("search_path"):
    #         LOGGER.debug("search path: %s", match.group("search_path_path"))
    #     elif match.group("trying_file"):
    #         LOGGER.debug("trying file: %s", match.group("trying_file_path"))
    #     elif match.group("search_cache"):
    #         LOGGER.debug("search cache: %s", match.group("search_cache_path"))
    #     elif match.group("calling_init"):
    #         LOGGER.debug("calling init: %s", match.group("calling_init_path"))
    #     elif match.group("initialize_program"):
    #         LOGGER.debug(
    #             "initialize program: %s", match.group("initialize_program_path")
    #         )
    #     elif match.group("transferring_control"):
    #         LOGGER.debug(
    #             "transferring control: %s", match.group("transferring_control_path")
    #         )
    #     elif match.group("calling_fini"):
    #         LOGGER.debug("calling fini: %s", match.group("calling_fini_path"))
