from functools import cache
from typing import Any
from pathlib import Path

_frozen_classes: dict[type, type] = {}

# make a derived class freezable (ie, disallow modifications).
# we do this by changing the class of an instance at runtime when freeze()
# is called, providing a derived class that is exactly the same except
# for a __setattr__ that raises an error when called. this beats having
# a field for frozenness and an unconditional __setattr__ that checks this
# field because it does not insert anything into the class dict.
class Freezeable:
    def freeze(self) -> None:
        cls = type(self)
        if not (frozen := _frozen_classes.get(cls)):
            def __setattr__(instance: Any, n: str, v: Any) -> None:
                raise TypeError(f'{cls.__name__} is frozen')
            frozen = type(cls.__name__, (cls,), {
                '__setattr__': __setattr__,
            })
            _frozen_classes[cls] = frozen
        self.__class__ = frozen

@cache
def relative_path_from(origin: str, to: str) -> str:
    """
    Calculate the relative path from origin file to destination file.

    Args:
        origin: The starting file path
        to: The target file path to reach

    Returns:
        A relative path string that leads from origin to destination

    Example:
        relative_path_from("index.html", "part1/chapters.html")
        # Returns: "part1/chapters.html"
    """
    origin_path = Path(origin).resolve()
    to_path = Path(to).resolve()

    # For file-to-file navigation, we calculate from the origin file's parent directory
    origin_dir = origin_path.parent

    # Calculate relative path from origin's directory to destination
    relative = to_path.relative_to(origin_dir, walk_up=True)
    return str(relative)
