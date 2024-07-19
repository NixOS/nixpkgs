import logging

import rich.logging

LOGGING_LEVEL = logging.INFO


def get_logger(name: str) -> logging.Logger:
    logger = logging.getLogger(name)
    logger.setLevel(LOGGING_LEVEL)

    handler = rich.logging.RichHandler(
        console=rich.console.Console(
            color_system=None,
            emoji=False,
            highlight=False,
            markup=False,
            stderr=True,
        ),
        rich_tracebacks=True,
        show_time=False,
    )
    handler.setFormatter(logging.Formatter("%(message)s"))
    logger.addHandler(handler)

    return logger
